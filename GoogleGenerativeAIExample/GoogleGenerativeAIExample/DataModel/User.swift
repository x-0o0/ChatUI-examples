//
//  User.swift
//  GoogleGenerativeAIExample
//
//  Created by Jaesung Lee on 2023/05/10.
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
        id: "PaLM",
        username: "PaLM",
        imageURL: URL(string: "https://the-decoder.com/wp-content/uploads/2022/09/google_palm_tree.jpg")!
    )
    
    static let me = User(id: "me", username: "j_sung_0o0")
}

