//
//  ChatView.swift
//  GoogleGenerativeAIExample
//
//  Created by Jaesung Lee on 2023/05/10.
//

import ChatUI
import SwiftUI

struct ChatView: View {
    @StateObject private var googleAI = PaLM()
    var body: some View {
        VStack(spacing: 0) {
            if googleAI.messages.isEmpty {
                Text("ChatUI X GoogleAI")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text("Start New Chat")
                    .font(.title3.bold())
                    .padding(.vertical, 12)
            } else {
                MessageList(googleAI.messages) { message in
                    MessageRow(message: message)
                        .padding(.top, 12)
                }
            }
            
            MessageField(
                options: [],
                showsSendButtonAlways: true
            ) { messageStyle in
                googleAI.sendMesssage(forStyle: messageStyle)
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
                .environmentObject(ChatConfiguration(userID: User.me.id))
                .environment(\.appearance, Appearance(
                    tint: Color(red: 0, green: 166 / 255, blue: 126 / 255),
                    localMessageBackground: Color(red: 0, green: 166 / 255, blue: 126 / 255)
                ))
        }
    }
}
