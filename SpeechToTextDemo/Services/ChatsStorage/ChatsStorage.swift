//
//  ChatsStorage.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation

protocol ChatsStorage {
    var chats: [ChatModel] { get }
    var messagesDict: [String: [Message]] { get set }

    func getChat(by id: String) -> ChatModel?
    func addNewChat(name: String)
    func getMessages(by chatId: String) -> [Message]
    mutating func addNewMessage(text: String, to chatId: String) -> [Message]
}

extension ChatsStorage {
    func getChat(by id: String) -> ChatModel? {
        chats.first(where: { $0.id == id })
    }

    func getMessages(by chatId: String) -> [Message] {
        messagesDict[chatId] ?? []
    }

    mutating func addNewMessage(text: String, to chatId: String) -> [Message] {
        var messages = messagesDict[chatId] ?? []
        let timestamp = Date().timeIntervalSince1970.description
        messages.append(.init(id: timestamp, text: text))
        messagesDict[chatId] = messages
        return messages
    }
}
