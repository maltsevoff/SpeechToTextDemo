//
//  ChatViewModel.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI
import Factory

final class ChatViewModel: ObservableObject {
    @Injected(\.chatsStorage) var chatsStorage

    @Published var recordState: RecordState = .normal
    var chat: ChatModel?
    var messagaes: [Message] = []

    init(chatId: String) {
        chat = chatsStorage.getChat(by: chatId)
        messagaes = chatsStorage.getMessages(by: chatId)
    }

    func startRecord() {

    }

    func stopRecord() {

    }
}

extension ChatViewModel {
    enum RecordState {
        case normal
        case recording
    }
}
