//
//  ChatsView.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI
import Factory

struct ChatsView: View {
    @StateObject var viewModel: ChatsViewModel

    var body: some View {
        List {
            ForEach(viewModel.chatsStorage.chats) { chat in
                ChatCell(chat: chat)
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let _ = Container.shared.chatsStorage.register { ChatsStorageMock() }
    ChatsView(viewModel: .init())
}
