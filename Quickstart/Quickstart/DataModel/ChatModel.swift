//
//  ChatChannelState.swift
//  Quickstart
//
//  Created by Jaesung Lee on 2023/02/09.
//

import SwiftUI
import ChatUI

class ChatModel: ObservableObject {
    @Published var messages: [ChatMessage] = [
        ChatMessage.photoFailedMessage,
        ChatMessage.message7,
        ChatMessage.locationMessage,
        ChatMessage.message6,
        ChatMessage.photoMessage,
        ChatMessage.message5,
        ChatMessage.message4,
        ChatMessage.message2,
        ChatMessage.message1,
    ]
    
    var didReadEventTimer: Timer?
    var didDeliverEventTimer: Timer?
    var didSendEventTimer: Timer?
    
    /// Send message
    /// - Parameter type: `MessageStyle` that indcates the message and its style such as image data, text, and so on.
    func sendMessage(_ type: MessageStyle) {
        let id = UUID().uuidString
        messages.insert(
            ChatMessage(
                id: id,
                sender: ChatUser.user1,
                sentAt: Date().timeIntervalSince1970,
                readReceipt: .sending,
                style: type
            ),
            at: 0
        )
        print("☺️ Send new message: \(id)")
    }
    
    init() {
        // Every 10 sec, `.delivered` -> `.seen`
        didReadEventTimer = Timer.scheduledTimer(
            withTimeInterval: 10.0,
            repeats: true,
            block: { _ in
                self.didRemoteUserReadMessage()
            }
        )
        // Every 1 sec, `.sending` -> `.sent`
        didSendEventTimer = Timer.scheduledTimer(
            withTimeInterval: 1.0,
            repeats: true,
            block: { _ in
                self.didSendMessage()
            }
        )
        // Every 3 sec, `.sent` -> `.delivered`
        didDeliverEventTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: true,
            block: { _ in
                self.didDeliverMessage()
            }
        )
    }
    
    func didRemoteUserReadMessage() {
        updateReadReciptStatus(from: .sent, to: .delivered)
        updateReadReciptStatus(from: .delivered, to: .seen)
    }

    func didDeliverMessage() {
        updateReadReciptStatus(from: .sent, to: .delivered)
    }
    
    func didSendMessage() {
        updateReadReciptStatus(from: .sending, to: .sent)
    }
    
    
    func updateReadReciptStatus(from: ReadReceipt, to: ReadReceipt) {
        guard messages.count > 0 else { return }
        for i in 0..<messages.count {
            if messages[i].readReceipt == from {
                let prev = messages[i]
                withAnimation {
                    messages[i] =
                    ChatMessage(
                        id: prev.id,
                        sender: prev.sender,
                        sentAt: prev.sentAt,
                        readReceipt: to,
                        style: prev.style
                    )                    
                }
            }
        }
    }
}
