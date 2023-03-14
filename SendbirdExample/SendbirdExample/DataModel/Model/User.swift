//
//  User.swift
//  SendbirdExample
//
//  Created by Jaesung Lee on 2023/03/10.
//

import ChatUI
import Foundation
import SendbirdChatSDK

struct User: Identifiable, UserProtocol {
    let id: String
    let username: String
    let imageURL: URL?
}

extension User {
    static let unknown = User(
        id: "unidentified",
        username: "Unknown User",
        imageURL: nil
    )
}


extension User {
    static let me = User(
        id: "me",
        username: "j_sung_0o0",
        imageURL: nil
    )
}

// MARK: - SendbirdChatSDK/User Extension

extension SendbirdChatSDK.User {
    var asUser: User {
        let imageURL = URL(string: self.profileURL ?? "https://picsum.photos/200")
        let user = User(
            id: self.userId,
            username: self.nickname,
            imageURL: imageURL
        )
        return user
    }
}
