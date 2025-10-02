//
//  Route.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation

enum Route: Hashable, Equatable {
    case chats
    case chat(chatId: String)
}
