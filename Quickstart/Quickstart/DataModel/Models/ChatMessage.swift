//
//  ChatMessage.swift
//  Quickstart
//
//  Created by Jaesung Lee on 2023/02/09.
//

import ChatUI
import Foundation

struct ChatMessage: MessageProtocol, Identifiable {
    typealias Sender = ChatUser
    
    var id: String
    var sender: ChatUser
    var sentAt: Double
    var editedAt: Double?
    var readReceipt: ReadReceipt
    var style: MessageStyle
}

extension ChatMessage {
    static let message1 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.bluebottle,
        sentAt: 1675331868,
        readReceipt: .seen,
        style: .text("Hi, there! I would like to ask about my order [#1920543](https://instagram.com/j_sung_0o0). Your agent mentioned that it would be available on [September 18](mailto:). However, I haven’t been notified yet by your company about my product availability. Could you provide me some news regarding it?")
    )
    
    static let message2 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.user1,
        sentAt: 1675342668,
        readReceipt: .seen,
        style: .text("Hi **Alexander**, we’re sorry to hear that. Could you give us some time to check on your order first? We will update you as soon as possible. Thanks!")
    )
    
    static let message3 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.starbucks,
        sentAt: 1675342668,
        readReceipt: .delivered,
        style: .text("Hi **Daniel**,\nThanks for your booking. We’re pleased to have you on board with us soon. Please find your travel details attached.")
    )
    
    static let message4 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.bluebottle,
        sentAt: 1675334868,
        readReceipt: .seen,
        style: .text("Do you know what time is it?")
    )
    
    static let message5 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.bluebottle,
        sentAt: 1675338868,
        readReceipt: .seen,
        style: .text("What is the most popular meal in Japan?")
    )
    
    static let message6 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.user1,
        sentAt: 1675404869,
        readReceipt: .delivered,
        style: .text("Do you know what time is it?")
    )
    
    static let message7 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.user1,
        sentAt: 1675408868,
        readReceipt: .sent,
        style: .text("What is the most popular meal in Japan?")
    )
    
    static let message8 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.user1,
        sentAt: 1675408868,
        readReceipt: .failed,
        style: .text("Read receipt status: `.failed`")
    )
    
    static let message9 = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.user1,
        sentAt: 1675408868,
        readReceipt: .sending,
        style: .text("Read receipt status: `.sending`")
    )
    
    static let locationMessage = ChatMessage(
        id: UUID().uuidString,
        sender: ChatUser.user1,
        sentAt: 1675408868,
        readReceipt: .delivered,
        style: .media(.location(37.57827, 126.97695))
    )
    
    static let photoMessage: ChatMessage = {
        let data = (try? Data(contentsOf: URL(string: "https://picsum.photos/220")!)) ?? Data()
        return ChatMessage(
            id: UUID().uuidString,
            sender: ChatUser.user1,
            sentAt: 1675408868,
            readReceipt: .delivered,
            style: .media(.photo(data))
        )
    }()
    
    static let photoFailedMessage: ChatMessage = {
        let data = Data()
        return ChatMessage(
            id: UUID().uuidString,
            sender: ChatUser.user1,
            sentAt: 1675408868,
            readReceipt: .failed,
            style: .media(.photo(data))
        )
    }()
}

