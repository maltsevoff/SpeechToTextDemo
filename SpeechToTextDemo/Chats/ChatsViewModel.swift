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

    init() {

    }

    func createNewChat(name: String) {
        chatsStorage.addNewChat(name: name)
    }
}
