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
            .navigationTitle(viewModel.chatName)
            .onAppear {
                viewModel.onAppear()
            }
    }

    private var rootView: some View {
        VStack {
            messagesList
                .padding(.horizontal, 16)
            footer
                .frame(height: 80)
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
        .scrollIndicators(.hidden)
    }

    @ViewBuilder
    private var footer: some View {
        if viewModel.micPermission == .granted && viewModel.speechPermission == .authorized {
            recordButton
        } else {
            HStack {
                micPermissionButton
                speechPermissionButton
            }
        }
    }

    private var micPermissionButton: some View {
        Button(action: {
            viewModel.requestMicrophonePermission()
        }, label: {
            switch viewModel.micPermission {
            case .undetermined:
                VStack {
                    Image(systemName: "microphone")
                    Text("Request microphone permission")
                }
            case .denied:
                VStack {
                    Image(systemName: "microphone")
                    Text("Permission denied")
                }
                .foregroundStyle(Color.red)
            case .granted:
                EmptyView()
            }
        })
    }

    private var speechPermissionButton: some View {
        Button(action: {
            viewModel.requestSpeechPermission()
        }, label: {
            switch viewModel.speechPermission {
            case .undetermined:
                VStack {
                    Image(systemName: "waveform.circle")
                    Text("Request recognition permission")
                }
            case .denied:
                VStack {
                    Image(systemName: "waveform.circle")
                    Text("Permission denied/restricted")
                }
                .foregroundStyle(Color.red)
            case .authorized:
                EmptyView()
            }
        })
    }

    private var recordButton: some View {
        Button(action: {
            viewModel.toggleRecord()
        }, label: {
            Circle()
                .fill(viewModel.recordState == .normal ? Color.blue : Color.red)
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
