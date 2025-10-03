//
//  SpeechToTextDemoApp.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI
import Factory

@main
struct SpeechToTextDemoApp: App {
    @InjectedObject(\.coordinator) var coordinator

    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $coordinator.path) {
                rootView
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                        case .chats:
                            ChatsView(viewModel: .init())
                        case .chat(let chatId):
                            ChatView(viewModel: .init(chatId: chatId))
                        }
                    }
            }
        }
    }

    private var rootView: some View {
        coordinator.start()
    }
}
