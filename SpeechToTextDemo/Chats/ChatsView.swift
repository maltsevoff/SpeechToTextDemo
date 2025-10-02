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
        rootView
            .navigationTitle("Chats")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Button(action: {
                    
                }, label: {
                    Image(systemName: "plus")
                        .foregroundStyle(.foreground)
                })
            }
    }

    private var rootView: some View {
        List {
            ForEach(viewModel.chatsStorage.chats) { chat in
                ChatCell(chat: chat)
                    .onTapGesture {
                        viewModel.open(chat: chat)
                    }
            }
        }
        .listStyle(.plain)
    }
}

#Preview {
    let _ = Container.shared.chatsStorage.register { ChatsStorageMock() }
    NavigationStack {
        ChatsView(viewModel: .init())
    }
}
