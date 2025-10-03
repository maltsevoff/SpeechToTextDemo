//
//  ChatView.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 02.10.2025.
//

import SwiftUI
import Factory

struct ChatView: View {
    @StateObject var viewModel: ChatViewModel

    var body: some View {
        rootView
    }

    private var rootView: some View {
        VStack {
            messagesList
                .padding(.horizontal, 16)
            recordButton
        }
        .overlay {
            if viewModel.recordState == .recording {
                Text(viewModel.transcript)
                    .frame(width: 180)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 16)
                    .background(Color.gray)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    private var messagesList: some View {
        ScrollView {
            LazyVStack {
                ForEach(viewModel.messagaes) { msg in
                    MessageCell(message: msg)
                }
            }
        }
        .defaultScrollAnchor(.bottom)
    }

    private var recordButton: some View {
        Button(action: {
            viewModel.toggleRecord()
        }, label: {
            Circle()
                .fill(viewModel.recordState == .normal ? Color.blue : Color.red)
                .frame(width: 80, height: 80)
                .overlay {
                    Image(systemName: "microphone")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 32, height: 32)
                        .foregroundStyle(.white)
                }
        })
    }
}

#Preview {
    let _ = Container.shared.chatsStorage.register { ChatsStorageMock() }
    ChatView(viewModel: .init(chatId: "1"))
}
