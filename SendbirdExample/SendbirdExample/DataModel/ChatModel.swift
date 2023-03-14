//
//  ChatModel.swift
//  SendbirdExample
//
//  Created by Jaesung Lee on 2023/03/10.
//

import ChatUI
import SwiftUI
import SendbirdChatSDK

protocol ChatModelProtocol {
    func sendMessage(style: MessageStyle)
}

/// [Provided by Sendbird Sample](https://github.com/sendbird/sendbird-uikit-ios/blob/main/Sample/QuickStart/AppDelegate.swift#:~:text=2D7B4CDB%2D932F%2D4082%2D9B09%2DA1153792DC8D)
let sendbirdAppID = "2D7B4CDB-932F-4082-9B09-A1153792DC8D"

@MainActor
class ChatModel: ObservableObject {
    @Published var channel: Channel?
    @Published var messages: [Message] = []
    @Published var user: User?
    
    var openChannel: OpenChannel? {
        didSet {
            SendbirdChat.addChannelDelegate(self, identifier: "com.chatui.examples.sendbird.open")
        }
    }
    var query: PreviousMessageListQuery?
    
    init() {
        initializeSDK()
        
        Task {
            do {
                self.user = try await signInUser(id: User.me.id)
                self.channel = try await startChatInChannel(url: "sendbird_open_channel_63320_05b9253ef65806c53a51b85a80b90af5dd6f7b80")
                self.messages = try await loadMessages()
            } catch {
                print(error.localizedDescription)
            }
            
        }
    }
    
    /// [Link](https://sendbird.com/docs/chat/v4/ios/getting-started/send-first-message#2-get-started-3-step-4-initialize-the-chat-sdk)
    private func initializeSDK() {
        let initParams = InitParams(
            applicationId: sendbirdAppID,
            isLocalCachingEnabled: true,
            logLevel: .info
        )

        SendbirdChat.initialize(params: initParams) {
            // Migration starts.
        } completionHandler: { error in
            // Migration completed.
        }
    }
    
    /// [Link](https://sendbird.com/docs/chat/v4/ios/getting-started/send-first-message#2-get-started-3-step-5-connect-to-the-sendbird-server)
    private func signInUser(id: String) async throws -> User {
        let sbUser = try await SendbirdChat.connect(userID: id)
        let user: User = sbUser.asUser
        return user
    }
    
    func startChatInChannel(url: String) async throws -> Channel {
        let sbChannel = try await OpenChannel.loadChannel(url: url)
        try await sbChannel.enter()
        self.openChannel = sbChannel
        return sbChannel.asChannel
    }
    
    func loadMessages() async throws -> [Message] {
        guard let openChannel else { return [] }
        self.query = openChannel.createPreviousMessageListQuery { params in
            params.reverse = true
        }
        guard let query else { return [] }
        let sbMessages = try await query.loadPreviousMessages()
        let messages = sbMessages.compactMap { $0.converted }
        return messages
    }

    func sendMessage(style: MessageStyle) {
        Task {
            guard let openChannel else { return }
            guard let user else { return }
            do {
                let tempID = UUID().uuidString
                let sendingMessage = Message(
                    id: tempID,
                    sender: user,
                    sentAt: Date().timeIntervalSince1970,
                    readReceipt: .sending,
                    style: style
                )
                self.messages.insert(sendingMessage, at: 0)
                switch style {
                case .text(let text):
                    
                    let sentMessage = try await openChannel.sendUserMessage(text)
                    // TODO: Sending message
                    print(sentMessage)
                    self.messages.removeAll { $0.id == tempID }
                    self.messages.insert(sentMessage.asMessage, at: 0)
                case .media(let mediaType):
                    let fileData: Data?
                    switch mediaType {
                    case .photo(let data):
                        fileData = data
                    case .video(let data):
                        fileData = data
                    case .document(let data):
                        fileData = data
                    default:
                        fileData = nil
                    }
                    guard let fileData else { return }
                    let sentMessage = try await openChannel.sendFileMessage(params: FileMessageCreateParams(file: fileData))
                    // TODO: Sending message
                    print(sentMessage)
                    self.messages.removeAll { $0.id == tempID }
                case .voice(let voiceData):
                    let sentMessage = try await openChannel.sendFileMessage(params: FileMessageCreateParams(file: voiceData))
                    // TODO: Sending message
                    print(sentMessage)
                    self.messages.removeAll { $0.id == tempID }
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

extension ChatModel: OpenChannelDelegate {
    func channel(_ channel: BaseChannel, didReceive message: BaseMessage) {
        switch message {
        case let userMessage as UserMessage:
            messages.insert(userMessage.asMessage, at: 0)
        case let fileMessage as FileMessage:
            messages.insert(fileMessage.asMessage, at: 0)
        case let adminMessage as AdminMessage:
            messages.insert(adminMessage.asMessage, at: 0)
        default: return
        }
    }
}

// MARK: - Async SendbirdChat
// TODO: New .swift File
enum SendbirdError: Error {
    // main
    case failedToConnect(_ description: String)
    // channel
    case failedToLoadChannel(_ description: String)
    case failedToEnterChannel(_ description: String)
    case failedToLoadMessages(_ description: String)
    // message
    case failedToSendMessage(_ description: String)
}

extension SendbirdChat {
    
    static func connect(userID: String) async throws -> SendbirdChatSDK.User {
        try await withCheckedThrowingContinuation { continuation in
            SendbirdChat.connect(userId: userID) { user, error in
                if let user = user {
                    continuation.resume(returning: user)
                } else {
                    continuation.resume(throwing: SendbirdError.failedToConnect(error?.description ?? "failed"))
                }
            }
        }
    }
}


