//
//  User.swift
//  ChatGPTExample
//
//  Created by Jaesung Lee on 2023/02/21.
//

import ChatUI
import Foundation

struct User: UserProtocol {
    var id: String
    var username: String
    var imageURL: URL?
}

extension User {
    static let chatBot = User(
        id: "chatbot",
        username: "ChatGPT",
        imageURL: URL(string: "https://stories.techncyber.com/wp-content/uploads/2022/12/chat-gpt-logo.jpg")!
    )
    
    static let me = User(id: "me", username: "j_sung_0o0")
}
