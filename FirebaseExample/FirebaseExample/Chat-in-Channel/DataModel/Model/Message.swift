//
//  Message.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

struct Message: Identifiable, Codable, MessageProtocol {
    var id: String
    var sender: User
    var sentAt: TimeInterval
    var editedAt: TimeInterval?
    var readReceipt: ReadReceipt
    var supportedStyle: SupportedMessageStyle
    var text: String?
    var data: Data?
    var latitude: Double?
    var longitude: Double?
    
    var style: MessageStyle {
        switch supportedStyle {
        case .text:
            return .text(text ?? "")
        case .gif:
            return .media(.gif(text ?? ""))
        case .photo:
            return .media(.photo(data ?? Data()))
        case .location:
            return .media(.location(latitude ?? 0, longitude ?? 0))
        }
    }
}

enum SupportedMessageStyle: String, Codable, Hashable {
    case text // string
    case gif // string
    case photo // data
    case location // float, float
}

