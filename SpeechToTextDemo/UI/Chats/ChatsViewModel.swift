//
//  ChatsViewModel.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation
import Factory

final class ChatsViewModel: ObservableObject {
    @Injected(\.chatsStorage) var chatsStorage
    @Injected(\.coordinator) var coordinator

    @Published var showingNewChatAlert = false
    @Published var newChatName = ""

    init() {

    }

    func showChatCreation() {
        newChatName = ""
        showingNewChatAlert = true
    }

    func createNewChat(name: String) {
        chatsStorage.addNewChat(name: name)
    }

    func open(chat: ChatModel) {
        coordinator.push(.chat(chatId: chat.id))
    }
}
