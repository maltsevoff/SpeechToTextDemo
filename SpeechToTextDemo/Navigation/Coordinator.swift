//
//  Coordinator.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI

final class Coordinator: ObservableObject {
    @Published var path = NavigationPath()

    func start() -> some View {
        ChatsView(viewModel: .init())
    }

    func push(_ route: Route) {
        path.append(route)
    }
}
