//
//  SpeechService.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 03.10.2025.
//

import Foundation

protocol SpeechService: Sendable {
    func authorize() async throws
    func transcribe() -> AsyncThrowingStream<String, Error>
    func stopTranscribing()
    func requestMicrophonePermission() async -> Bool
}
