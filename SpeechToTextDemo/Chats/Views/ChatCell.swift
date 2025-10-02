//
//  ChatCell.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI

struct ChatCell: View {
    let chat: ChatModel

    var body: some View {
        HStack {
            Text(chat.name)
        }
    }
}
