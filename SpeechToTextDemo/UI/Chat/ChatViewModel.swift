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

    var chat: ChatModel?
    var messagaes: [Message] = []

    init(chatId: String) {
        chat = chatsStorage.getChat(by: chatId)
        messagaes = chatsStorage.getMessages(by: chatId)
    }
}
