//
//  ChatViewModel.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI
import Factory
import Speech
import AVFoundation

@MainActor
final class ChatViewModel: ObservableObject {
    @Injected(\.chatsStorage) var chatsStorage
    @Injected(\.speechService) var speechService

    @Published var recordState: RecordState = .normal
    @Published var transcript = ""
    @Published var errorMessage: String?
    @Published var chatName = ""
    @Published var showErrorAlert = false
    @Published var micPermission: MicrophonePermissionStatus = .undetermined
    @Published var speechPermission: SpeechPermissionStatus = .undetermined
    @Published var isSpeechRecognitionAvailable: Bool = false
    var chat: ChatModel?
    var messagaes: [Message] = []

    private let chatId: String
    private var transcriptionTask: Task<Void, Never>?

    init(chatId: String) {
        self.chatId = chatId
        chat = chatsStorage.getChat(by: chatId)
        messagaes = chatsStorage.getMessages(by: chatId)
        chatName = chat?.name ?? ""
    }

    func onAppear() {
        Task {
            isSpeechRecognitionAvailable = await speechService.isSpeechRecognitionAvailable()
            micPermission = await speechService.getMicPermissionStatus()
            speechPermission = await speechService.getSpeechPermissionStatus()
        }
    }

    func requestMicrophonePermission() {
        Task {
            micPermission = (await speechService.requestMicrophonePermission()) ? .granted : .denied
        }
    }
    
    func requestSpeechPermission() {
        Task {
            speechPermission = (await speechService.requestSpeechPermission()) ? .authorized : .denied
        }
    }

    func toggleRecord() {
        Task {
            switch recordState {
            case .normal:
                startRecord()
            case .recording:
                await stopRecord()
            }
        }
    }

    func startRecord() {
        guard recordState != .recording else { return }

        recordState = .recording

        transcriptionTask?.cancel()
        transcriptionTask = Task { @MainActor in
            do {
                try await speechService.authorize()

                let stream = await speechService.transcribe()
                for try await partialResult in stream {
                    print(partialResult)
                    self.transcript = partialResult
                }
                await speechService.stopTranscribing()
            } catch let error as SpeechServiceError {
                await speechService.stopTranscribing()
                switch error {
                case .nilRecognizer:
                    self.errorMessage = error.localizedDescription
                    self.recordState = .normal
                case .notAuthorizedToRecognize:
                    self.errorMessage = error.localizedDescription
                    self.recordState = .normal
                case .notPermittedToRecord:
                    self.errorMessage = error.localizedDescription
                    self.recordState = .normal
                case .recognizerUnavailable:
                    self.errorMessage = error.localizedDescription
                    self.recordState = .normal
                case .invalidAudioSession:
                    self.errorMessage = error.localizedDescription
                    self.recordState = .normal
                }
            } catch {
                await speechService.stopTranscribing()
                self.errorMessage = error.localizedDescription
                self.recordState = .normal
            }
        }
    }

    private func stopRecord() async {
        guard recordState == .recording else { return }

        recordState = .normal
        transcriptionTask?.cancel()
        transcriptionTask = nil
        await speechService.stopTranscribing()

        addNewMessage(text: transcript)
        transcript = ""
    }

    private func addNewMessage(text: String) {
        guard !text.isEmpty else { return }
        
        let newMessages = chatsStorage.addNewMessage(text: text, to: chatId)
        messagaes = newMessages
    }
}

extension ChatViewModel {
    enum RecordState {
        case normal
        case recording
    }
}
