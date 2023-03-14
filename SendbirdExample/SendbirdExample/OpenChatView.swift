//
//  OpenChatView.swift
//  SendbirdExample
//
//  Created by Jaesung Lee on 2023/03/10.
//

import ChatUI
import SwiftUI

struct OpenChatView: View {
    @Environment(\.appearance) var appearance
    @StateObject var chat = ChatModel()
    @State var isMessageFieldPresented: Bool = true
    
    var body: some View {
        if let channel = chat.channel {
            ChannelStack(channel) {
                MessageList(chat.messages) { message in
                    MessageRow(message: message, showsReadReceiptStatus: false)
                        .padding(.top, 12)
                } menuContent: { message in
                    MessageMenu {
                        Button{
                            highlightMessagePublisher.send(nil)
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
                        
                        Divider()
                        
                        Button{
                            highlightMessagePublisher.send(nil)
                        } label: {
                            HStack {
                                Text("Report **@\(message.sender.username)**")
                                
                                Spacer()
                                
                                Image(systemName: "person.crop.circle.badge.exclamationmark")
                            }
                            .padding(.horizontal, 16)
                            .foregroundColor(appearance.primary)
                        }
                        .frame(height: 44)
                        
                        Divider()
                        
                        Button{
                            highlightMessagePublisher.send(nil)
                        } label: {
                            HStack {
                                Text("Block **@\(message.sender.username)**")
                                
                                Spacer()
                                
                                Image(systemName: "person.crop.circle.badge.xmark")
                            }
                            .padding(.horizontal, 16)
                            .foregroundColor(appearance.error)
                        }
                        .frame(height: 44)
                    }
                    .padding(.top, 12)
                }

                if isMessageFieldPresented {
                    MessageField(options: [], showsSendButtonAlways: true) { messageStyle in
                        chat.sendMessage(style: messageStyle)
                    }
                }
            }
            .onReceive(highlightMessagePublisher) { highlightMessage in
                withAnimation {
                    isMessageFieldPresented = highlightMessage == nil
                }
            }
        } else {
            VStack(spacing: 0) {
                Text("ChatUI X Sendbird")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.secondary)
                
                Text("LOADING")
                    .font(.title3.bold())
                    .padding(.vertical, 12)
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            OpenChatView()
                .environmentObject(ChatConfiguration(userID: User.me.id))
                .environment(\.appearance, Appearance(
                    tint: Color(red: 116 / 255, green: 45 / 255, blue: 221 / 255),
                    localMessageBackground: Color(red: 116 / 255, green: 45 / 255, blue: 221 / 255),
                    remoteMessageBackground: Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255)
                ))
        }
        
    }
}
