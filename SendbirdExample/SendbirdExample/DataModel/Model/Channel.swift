//
//  Channel.swift
//  SendbirdExample
//
//  Created by Jaesung Lee on 2023/03/10.
//

import ChatUI
import Foundation
import SendbirdChatSDK

struct Channel: Identifiable, ChannelProtocol {
    var id: String
    var name: String
    var imageURL: URL?
    var createdAt: TimeInterval
    var members: [User]
    var lastMessage: Message?
    let membersCount: Int
}


// MARK: - SendbirdChatSDK/GroupChannel Extension

extension SendbirdChatSDK.GroupChannel {
    var asChannel: Channel {
        let imageURL = URL(string: self.coverURL ?? "https://picsum.photos/200")
        let members = self.members.compactMap { $0.asUser }
        let channel = Channel(
            id: self.channelURL,
            name: self.name,
            imageURL: imageURL,
            createdAt: Double(self.createdAt) / 1000,
            members: members,
            membersCount: Int(self.memberCount)
        )
        return channel
    }
    
    static func loadChannel(url: String) async throws -> GroupChannel {
        try await withCheckedThrowingContinuation { continuation in
            GroupChannel.getChannel(url: url) { channel, error in
                if let channel = channel {
                    continuation.resume(returning: channel)
                } else {
                    continuation.resume(throwing: SendbirdError.failedToLoadChannel(error?.description ?? "failed"))
                }
            }
        }
    }
}

// MARK: - SendbirdChatSDK/OpenChannel Extension

extension SendbirdChatSDK.OpenChannel {
    var asChannel: Channel {
        let imageURL = URL(string: self.coverURL ?? "https://picsum.photos/200")
        let channel = Channel(
            id: self.channelURL,
            name: self.name,
            imageURL: imageURL,
            createdAt: Double(self.createdAt) / 1000,
            members: [],
            membersCount: self.participantCount
        )
        return channel
    }
    
    static func loadChannel(url: String) async throws -> OpenChannel {
        try await withCheckedThrowingContinuation { continuation in
            OpenChannel.getChannel(url: url) { channel, error in
                if let channel = channel {
                    continuation.resume(returning: channel)
                } else {
                    continuation.resume(throwing: SendbirdError.failedToLoadChannel(error?.description ?? "failed"))
                }
            }
        }
    }
    
    func enter() async throws {
        try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>)  in
            self.enter { error in
                if let error = error {
                    continuation.resume(throwing: SendbirdError.failedToEnterChannel(error.description))
                } else {
                    continuation.resume()
                }
            }
        }
    }
    
    func sendUserMessage(_ text: String) async throws -> UserMessage {
        try await withCheckedThrowingContinuation { continuation in
            self.sendUserMessage(text) { message, error in
                if let message = message {
                    continuation.resume(returning: message)
                } else {
                    continuation.resume(throwing: SendbirdError.failedToSendMessage(error?.description ?? ""))
                }
            }
        }
    }
    
    func sendFileMessage(params: FileMessageCreateParams) async throws -> FileMessage {
        try await withCheckedThrowingContinuation { continuation in
            self.sendFileMessage(params: params) { message, error in
                if let message = message {
                    continuation.resume(returning: message)
                } else {
                    continuation.resume(throwing: SendbirdError.failedToSendMessage(error?.description ?? ""))
                }
            }
        }
    }
}

extension SendbirdChatSDK.PreviousMessageListQuery {
    func loadPreviousMessages() async throws -> [BaseMessage] {
        try await withCheckedThrowingContinuation { continuation in
            self.loadNextPage { messages, error in
                if let messages = messages {
                    continuation.resume(returning: messages)
                } else {
                    continuation.resume(throwing: SendbirdError.failedToLoadChannel(error?.description ?? ""))
                }
            }
        }
    }
}
