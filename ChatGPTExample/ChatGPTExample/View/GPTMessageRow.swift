//
//  GPTMessageRow.swift
//  ChatGPTExample
//
//  Created by Jaesung Lee on 2023/03/14.
//

import ChatUI
import SwiftUI

struct GPTMessageRow: View {
    @State var text: String = ""
    let message: Message
    let isLastMessage: Bool
    var finalText: String {
        switch message.style {
        case .text(let text):
            return text
        default:
            return ""
        }
    }
    
    var body: some View {
        MessageRow(
            message: Message(
                id: message.id,
                sentAt: message.sentAt,
                readReceipt: message.readReceipt,
                style: .text(text),
                sender: message.sender
            ),
            showsUsername: false,
            showsProfileImage: false
        )
        .onAppear {
            if message.sender == User.chatBot, isLastMessage {
                typeWriter()
            } else {
                text = finalText
            }
        }
    }
    
    init(message: Message, isLastMessage: Bool) {
        self.message = message
        self.isLastMessage = isLastMessage
    }
    
    func typeWriter(at position: Int = 0) {
        if position < finalText.count {
            // Run the code inside the DispatchQueue after 0.2s
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
              text.append(finalText[position])
              typeWriter(at: position + 1)
            }
          }
    }
}

extension String {
    /// The extension method that is used in ``GPTMessageRow/typeWriter(at:)``
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
