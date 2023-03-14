//
//  Message.swift
//  SendbirdExample
//
//  Created by Jaesung Lee on 2023/03/10.
//

import ChatUI
import Foundation
import SendbirdChatSDK

struct Message: Identifiable, MessageProtocol {
    var id: String
    var sender: User
    var sentAt: TimeInterval
    var editedAt: TimeInterval?
    var readReceipt: ReadReceipt
    var style: MessageStyle
//    /// ID of Sending message
//    var requestID: String
}

// MARK: - SendbirdChatSDK/UserMessage Extension
extension SendbirdChatSDK.BaseMessage {
    var converted: Message? {
        switch self {
        case let userMessage as UserMessage:
            return userMessage.asMessage
        case let fileMessage as FileMessage:
            return fileMessage.asMessage
        case let adminMessage as AdminMessage:
            return adminMessage.asMessage
        default:
            return nil
        }
    }
}

// MARK: - SendbirdChatSDK/UserMessage Extension
extension SendbirdChatSDK.UserMessage {
    var asMessage: Message {
        let style = MessageStyle.text(self.message)
        let readRecipt: ReadReceipt
        switch sendingStatus {
        case .pending:
            readRecipt = .sending
        case .failed:
            readRecipt = .failed
        case .succeeded:
            readRecipt = .sent
        default:
            readRecipt = .failed
        }
        let message = Message(
            id: "\(self.messageId)",
            sender: self.sender?.asUser ?? User.unknown,
            sentAt: TimeInterval(self.createdAt) / 1000,
            editedAt: TimeInterval(self.updatedAt) / 1000,
            readReceipt: readRecipt,
            style: style
        )
        return message
    }
}

// MARK: - SendbirdChatSDK/FileMessage Extension
extension SendbirdChatSDK.FileMessage {
    var asMessage: Message {
//        let mediaType = MediaType.photo(URL(string: self.url)!)
//        let sytle = MessageStyle.media(mediaType)
        let fileURL = URL(string: self.url)!
        let fileType = self.type.lowercased()
        var style: MessageStyle = .media(.photo(Data()))
        
        // TODO: main thread issue
        if let data = try? Data(contentsOf: fileURL) {
            if fileType.hasPrefix("image") {
                style = .media(.photo(data))
            } else if fileType.hasPrefix("video") {
                style = .media(.video(data))
            } else if fileType.hasPrefix("audio") {
                style = .voice(data)
            }
        }
        
        let readRecipt: ReadReceipt
        switch sendingStatus {
        case .pending:
            readRecipt = .sending
        case .failed:
            readRecipt = .failed
        case .succeeded:
            readRecipt = .sent
        default:
            readRecipt = .failed
        }
        let message = Message(
            id: "\(self.messageId)",
            sender: self.sender?.asUser ?? User.unknown,
            sentAt: TimeInterval(self.createdAt) / 1000,
            editedAt: TimeInterval(self.updatedAt) / 1000,
            readReceipt: readRecipt,
            style: style
        )
        return message
    }
}

// MARK: - SendbirdChatSDK/AdminMessage Extension
extension SendbirdChatSDK.AdminMessage {
    var asMessage: Message {
        let style = MessageStyle.text(self.message)
        let readRecipt: ReadReceipt
        switch sendingStatus {
        case .pending:
            readRecipt = .sending
        case .failed:
            readRecipt = .failed
        case .succeeded:
            readRecipt = .sent
        default:
            readRecipt = .failed
        }
        let message = Message(
            id: "\(self.messageId)",
            sender: self.sender?.asUser ?? User.unknown,
            sentAt: TimeInterval(self.createdAt) / 1000,
            editedAt: TimeInterval(self.updatedAt) / 1000,
            readReceipt: readRecipt,
            style: style
        )
        return message
    }
}
