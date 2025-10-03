//
//  ChatsStorage.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation

protocol ChatsStorage {
    var chats: [ChatModel] { get }
    var messagesDict: [String: [Message]] { get }

    func getChat(by id: String) -> ChatModel?
    func addNewChat(name: String)
    func getMessages(by chatId: String) -> [Message]
}

extension ChatsStorage {
    func getChat(by id: String) -> ChatModel? {
        chats.first(where: { $0.id == id })
    }

    func getMessages(by chatId: String) -> [Message] {
        messagesDict[chatId] ?? []
    }
}
