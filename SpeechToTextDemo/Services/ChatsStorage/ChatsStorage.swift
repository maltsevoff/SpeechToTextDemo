//
//  ChatsStorage.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation

protocol ChatsStorage {
    var chats: [ChatModel] { get }
    
    func addNewChat(name: String)
}
