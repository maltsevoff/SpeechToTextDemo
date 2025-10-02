//
//  ChatsStorageImpl.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation

class ChatsStorageImpl: ChatsStorage {
    var chats: [ChatModel] = []

    func addNewChat(name: String) {
        chats.append(ChatModel(id: UUID().uuidString, name: name))
    }
}

class ChatsStorageMock: ChatsStorage {
    var chats: [ChatModel] = [
        .init(id: "1", name: "chat 1"),
        .init(id: "2", name: "chat 2"),
        .init(id: "3", name: "chat 3"),
        .init(id: "4", name: "chat 4"),
        .init(id: "5", name: "chat 5"),
        .init(id: "6", name: "chat 6"),
        .init(id: "7", name: "chat 7"),
        .init(id: "8", name: "chat 8"),
    ]

    func addNewChat(name: String) {
        chats.append(ChatModel(id: UUID().uuidString, name: name))
    }
}
