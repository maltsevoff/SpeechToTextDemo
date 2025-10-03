//
//  ChatViewModel.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI
import Factory

@MainActor
final class ChatViewModel: ObservableObject {
    @Injected(\.chatsStorage) var chatsStorage
    @Injected(\.speechService) var speechService

    @Published var recordState: RecordState = .normal
    @Published var transcript = ""
    @Published var errorMessage: String?
    var chat: ChatModel?
    var messagaes: [Message] = []

    private let chatId: String
    private var transcriptionTask: Task<Void, Never>?

    init(chatId: String) {
        self.chatId = chatId
        chat = chatsStorage.getChat(by: chatId)
        messagaes = chatsStorage.getMessages(by: chatId)
    }

    func toggleRecord() {
        switch recordState {
        case .normal:
            startRecord()
        case .recording:
            stopRecord()
        }
    }

    func startRecord() {
        guard recordState != .recording else { return }

        recordState = .recording

        transcriptionTask?.cancel()
        transcriptionTask = Task { @MainActor in
            do {
                try await speechService.authorize()

                let stream = speechService.transcribe()
                for try await partialResult in stream {
                    self.transcript = partialResult
                }
            } catch {
                self.errorMessage = error.localizedDescription
                self.recordState = .normal
            }
        }
    }

    func stopRecord() {
        guard recordState == .recording else { return }

        recordState = .normal
        transcriptionTask?.cancel()
        transcriptionTask = nil
        speechService.stopTranscribing()

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
