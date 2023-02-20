//
//  User.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import Foundation

struct User: Identifiable, Codable, UserProtocol {
    let id: String
    let username: String
    let imageURL: URL?
}

extension User {
    static let me = User(
        id: "me",
        username: "j_sung_0o0",
        imageURL: nil
    )
}
