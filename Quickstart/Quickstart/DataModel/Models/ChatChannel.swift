//
//  ChatChannel.swift
//  Quickstart
//
//  Created by Jaesung Lee on 2023/02/09.
//

import ChatUI
import Foundation

struct ChatChannel: ChannelProtocol {
    typealias U = ChatUser
    typealias M = ChatMessage
    
    var id: String
    var name: String
    var imageURL: URL?
    var members: [ChatUser]
    var createdAt: Double
    var lastMessage: ChatMessage?
}

extension ChatChannel {
    static let channel1 = ChatChannel(
        id: ChatUser.bluebottle.id,
        name: ChatUser.bluebottle.username,
        imageURL: ChatUser.bluebottle.imageURL,
        members: [ChatUser.user1, ChatUser.bluebottle],
        createdAt: 1675242048,
        lastMessage: nil
    )
    
    static let new = ChatChannel(
        id: UUID().uuidString,
        name: ChatUser.user2.username,
        imageURL: nil,
        members: [ChatUser.user1, ChatUser.user2],
        createdAt: 1675860481,
        lastMessage: ChatMessage.message1
    )
}

