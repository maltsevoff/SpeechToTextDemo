//
//  SpeechServiceImpl.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 03.10.2025.
//

import AVFoundation
import Foundation
@preconcurrency import Speech

actor SpeechServiceImpl: SpeechService {
    private var accumulatedText: String = ""

    private var audioEngine: AVAudioEngine?
    private var request: SFSpeechAudioBufferRecognitionRequest?
    private var task: SFSpeechRecognitionTask?
    private let recognizer: SFSpeechRecognizer?

    init(localeIdentifier: String = Locale.current.identifier) {
        self.recognizer = SFSpeechRecognizer(locale: Locale(identifier: localeIdentifier))
    }

    func authorize() async throws {
        guard let recognizer = self.recognizer else {
            throw SpeechServiceError.recognizerUnavailable
        }

        let hasAuthorization = await SFSpeechRecognizer.hasAuthorizationToRecognize()
        guard hasAuthorization else {
            throw SpeechServiceError.notAuthorizedToRecognize
        }

        let hasRecordPermission = await AVAudioApplication.requestRecordPermission()
        guard hasRecordPermission else {
            throw SpeechServiceError.notPermittedToRecord
        }

        if !recognizer.isAvailable {
            throw SpeechServiceError.recognizerUnavailable
        }
    }

    func transcribe() async -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    let (audioEngine, request) = try Self.prepareEngine()
                    self.audioEngine = audioEngine
                    self.request = request

                    guard let recognizer = self.recognizer else {
                        throw SpeechServiceError.recognizerUnavailable
                    }

                    self.task = recognizer.recognitionTask(with: request) { result, error in
                        if let error = error {
                            continuation.finish(throwing: error)
                            return
                        }

                        if let result = result {
                            let newText = result.bestTranscription.formattedString

                            continuation.yield(newText)

                            if result.isFinal {
                                continuation.finish()
                            }
                        }
                    }
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }

    func stopTranscribing() async {
        reset()
    }

    func isSpeechRecognitionAvailable() async -> Bool {
        recognizer?.supportsOnDeviceRecognition ?? false
    }

    func requestMicrophonePermission() async -> Bool {
        await AVAudioApplication.requestRecordPermission()
    }

    func requestSpeechPermission() async -> Bool {
        await SFSpeechRecognizer.hasAuthorizationToRecognize()
    }

    func getSpeechPermissionStatus() async -> SpeechPermissionStatus {
        .init(await SFSpeechRecognizer.getAuthorizationToRecordStatus())
    }

    func getMicPermissionStatus() async -> MicrophonePermissionStatus {
        .init(AVAudioApplication.shared.recordPermission)
    }

    func reset() {
        task?.cancel()
        task = nil
        audioEngine?.stop()
        audioEngine = nil
        request = nil
        accumulatedText = ""
    }

    private static func prepareEngine() throws -> (AVAudioEngine, SFSpeechAudioBufferRecognitionRequest) {
        let audioEngine = AVAudioEngine()
        let request = SFSpeechAudioBufferRecognitionRequest()
        request.addsPunctuation = true
        request.taskHint = .dictation
        request.shouldReportPartialResults = true

        let audioSession = AVAudioSession.sharedInstance()
        try audioSession.setCategory(.playAndRecord, mode: .measurement, options: .duckOthers)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { buffer, _ in
            request.append(buffer)
        }

        audioEngine.prepare()
        try audioEngine.start()

        return (audioEngine, request)
    }
}
