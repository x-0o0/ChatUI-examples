//
//  ChatView.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import SwiftUI

struct ChatView: View {
    @Environment(\.appearance) var appearance
    @StateObject private var chat = ChatModel()
    @State private var isMenuPresented: Bool = false
    
    var body: some View {
        if let channel = chat.channel {
            NavigationView {
                ChannelStack(channel) {
                    MessageList(chat.messages, showsDate: true) { message in
                        MessageRow(message: message)
                            .padding(.top, 12)
                    } menuContent: { message in
                        MessageMenu {
                            // Copy action
                            Button {
                                copyMessage(style: message.style)
                            } label: {
                                HStack {
                                    Text("Copy")
                                    
                                    Spacer()
                                    
                                    Image(systemName: "doc.on.doc")
                                }
                                .padding(.horizontal, 16)
                                .foregroundColor(appearance.primary)
                            }
                            .frame(height: 44)
                        }
                        .padding(.top, 12)
                    }
                    
                    MessageField(
                        options: [.photoLibrary, .menu, .giphy],
                        showsSendButtonAlways: true,
                        isMenuItemPresented: $isMenuPresented
                    ) { messageStyle in
                        chat.sendMessage(style: messageStyle)
                    }
                    
                    if isMenuPresented {
                        LocationSelector(isPresented: $isMenuPresented)
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
            }
        } else {
            VStack(spacing: 0) {
                Text("ChatUI X Firebase")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text("Start New Chat")
                    .font(.title3.bold())
                    .padding(.vertical, 12)
                
                
                MessageField(
                    options: [],
                    showsSendButtonAlways: true
                ) { messageStyle in
                    chat.sendMessage(style: messageStyle)
                }
            }
        }
    }
    
    func copyMessage(style: MessageStyle) {
        switch style {
        case .text(let string):
            UIPasteboard.general.string = string
        default: break
        }
        highlightMessagePublisher.send(nil)
    }
}

