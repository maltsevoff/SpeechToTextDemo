//
//  SpeechService.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 03.10.2025.
//

import Foundation
import Speech

protocol SpeechService: Sendable {
    func authorize() async throws
    func transcribe() async -> AsyncThrowingStream<String, Error>
    func stopTranscribing() async
    func requestMicrophonePermission() async -> Bool
    func requestSpeechPermission() async -> Bool
    func getMicPermissionStatus() async -> MicrophonePermissionStatus
    func getSpeechPermissionStatus() async -> SpeechPermissionStatus
    func isSpeechRecognitionAvailable() async -> Bool
}

enum MicrophonePermissionStatus {
    case undetermined
    case granted
    case denied

    init(_ status: AVAudioApplication.recordPermission) {
        switch status {
        case .granted:
            self = .granted
        case .denied:
            self = .denied
        case .undetermined:
            self = .undetermined
        @unknown default:
            self = .undetermined
        }
    }
}

enum SpeechPermissionStatus {
    case undetermined
    case authorized
    case denied

    init(_ status: SFSpeechRecognizerAuthorizationStatus) {
        switch status {
        case .notDetermined:
            self = .undetermined
        case .denied:
            self = .denied
        case .restricted:
            self = .denied
        case .authorized:
            self = .authorized
        @unknown default:
            self = .undetermined
        }
    }
}
