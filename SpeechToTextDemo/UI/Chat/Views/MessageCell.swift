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

                Text(message.text)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .frame(minHeight: 40)
                    .background(Color.blue)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
            }
        }
        .frame(maxWidth: .infinity)
    }
}
