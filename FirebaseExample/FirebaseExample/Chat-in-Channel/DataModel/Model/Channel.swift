//
//  Channel.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Channel: Identifiable, Codable, ChannelProtocol {
    @DocumentID var documentId: String?
    var id: String { documentId ?? ""}
    var name: String
    var imageURL: URL?
    var createdAt: TimeInterval
    var members: [User]
    var lastMessage: Message?
}

extension Channel {
    static func newChannel(named name: String) -> Channel {
        return Channel(
            name: name,
            imageURL: URL(string: "https://picsum.photos/200"),
            createdAt: Date().timeIntervalSince1970,
            members: [User.me]
        )
    }
}
