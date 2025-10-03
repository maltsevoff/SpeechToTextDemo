//
//  MessageCell.swift
//  SpeechToTextDemo
//
//  Created by Aleksandr Maltsev on 03.10.2025.
//

import SwiftUI

struct MessageCell: View {
    let message: Message

    var body: some View {
        ZStack {
            HStack {
                Spacer()

                Text("id: \(message.id)")

                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.blue)
                    .clipShape(Capsule())
            }
        }
        .frame(maxWidth: .infinity)
    }
}
