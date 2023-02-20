//
//  ChatView.swift
//  ChatGPTExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import SwiftUI

struct ChatView: View {
    @StateObject private var chatGPT = ChatGPT()
    var body: some View {
        VStack(spacing: 0) {
            if chatGPT.messages.isEmpty {
                Text("ChatUI X ChatGPT")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text("Start New Chat")
                    .font(.title3.bold())
                    .padding(.vertical, 12)
            } else {
                MessageList(chatGPT.messages) { message in
                    MessageRow(message: message)
                        .padding(.top, 12)
                }
            }
            
            MessageField(
                options: [],
                showsSendButtonAlways: true
            ) { messageStyle in
                chatGPT.sendMesssage(forStyle: messageStyle)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatView()
    }
}
