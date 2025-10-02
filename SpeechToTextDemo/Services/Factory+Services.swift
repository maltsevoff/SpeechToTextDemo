//
//  Factory+Services.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import Foundation
import Factory

extension Container {
    var chatsStorage: Factory<ChatsStorage> {
        Factory(self) { ChatsStorageImpl() }
    }
}
