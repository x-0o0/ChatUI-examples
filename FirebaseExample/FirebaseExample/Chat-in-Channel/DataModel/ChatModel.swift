//
//  ChatModel.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class ChatModel: ObservableObject {
    @Published var channel: Channel?
    @Published var messages: [Message] = []
    
    var channelDocumentID: String?
    var db = Firestore.firestore()
    
    // MARK: Virtual Remote User's Interaction
    var didReadEventTimer: Timer?
    var didDeliverEventTimer: Timer?
    
    init() {
        // MARK: Virtual Remote User's Interaction
        // Every 10 sec, `.delivered` -> `.seen`
        didReadEventTimer = Timer.scheduledTimer(
            withTimeInterval: 10.0,
            repeats: true,
            block: { _ in
                self.didRemoteUserReadMessage()
            }
        )
        
        // Every 3 sec, `.sent` -> `.delivered`
        didDeliverEventTimer = Timer.scheduledTimer(
            withTimeInterval: 3.0,
            repeats: true,
            block: { _ in
                self.didDeliverMessage()
            }
        )
    }

    func sendMessage(style: MessageStyle) {
        do {
            // Create channel if `selectedChannel` is `nil`
            let channel = try createChannel(with: style)
            guard let documentID = channel.documentId else { return }
            
            // Create message
            let newMessage = self.createMessage(withStyle: style)
            
            let _ = try db.collection("channels")
                .document(documentID)
                .collection("messages")
                .document(newMessage.id)
                .setData(
                    from: newMessage,
                    completion: { [self] error in
                        self.didSendMessage()
                    }
                )
            
            self.messages.insert(newMessage, at: 0)
        } catch {
            print(error)
        }
    }
    
    // MARK: Create a new channel with first message
    func createChannel(with firstMessage: MessageStyle) throws -> Channel {
        if let channel = self.channel { return channel }
        switch firstMessage {
        case .text(let name):
            var newChannel = Channel.newChannel(named: "\(name.prefix(20))")
            let newChannelRef = try db.collection("channels").addDocument(from: newChannel)
            newChannel.documentId = newChannelRef.documentID
            withAnimation {
                self.channel = newChannel
            }
            return newChannel
        default:
            throw NSError(domain: "com.chatui.examples.firebase.error", code: 400)
        }
    }

    func createMessage(withStyle style: MessageStyle) -> Message {
        let message: Message
        switch style {
        case .text(let text):
            message = Message(
                id: UUID().uuidString,
                sender: User.me,
                sentAt: Date().timeIntervalSince1970,
                readReceipt: .sending,
                supportedStyle: .text,
                text: text
            )
        case .media(let mediaType):
            switch mediaType {
            case .gif(let id):
                message = Message(
                    id: UUID().uuidString,
                    sender: User.me,
                    sentAt: Date().timeIntervalSince1970,
                    readReceipt: .sending,
                    supportedStyle: .gif,
                    text: id
                )
            case .photo(let data):
                message = Message(
                    id: UUID().uuidString,
                    sender: User.me,
                    sentAt: Date().timeIntervalSince1970,
                    readReceipt: .sending,
                    supportedStyle: .photo,
                    data: data
                )
            case .location(let lat, let lng):
                message = Message(
                    id: UUID().uuidString,
                    sender: User.me,
                    sentAt: Date().timeIntervalSince1970,
                    readReceipt: .sending,
                    supportedStyle: .location,
                    latitude: lat,
                    longitude: lng
                )
            default:
                message = Message(
                    id: UUID().uuidString,
                    sender: User.me,
                    sentAt: Date().timeIntervalSince1970,
                    readReceipt: .sending,
                    supportedStyle: .text,
                    text: "unknown"
                )
            }
        default:
            message = Message(
                id: UUID().uuidString,
                sender: User.me,
                sentAt: Date().timeIntervalSince1970,
                readReceipt: .sending,
                supportedStyle: .text,
                text: "unknown"
            )
        }
        return message
    }
    
    // MARK: Virtual Remote User's Interaction
    func didRemoteUserReadMessage() {
        updateReadReciptStatus(from: .sent, to: .delivered)
        updateReadReciptStatus(from: .delivered, to: .seen)
    }

    // MARK: Virtual Remote User's Interaction
    func didDeliverMessage() {
        updateReadReciptStatus(from: .sent, to: .delivered)
    }
    
    func didSendMessage() {
        updateReadReciptStatus(from: .sending, to: .sent)
    }
    
    func updateReadReciptStatus(from: ReadReceipt, to: ReadReceipt) {
        guard messages.count > 0 else { return }
        for i in 0..<messages.count {
            if messages[i].readReceipt == from {
                let prev = messages[i]
                withAnimation {
                    messages[i] =
                    Message(
                        id: prev.id,
                        sender: prev.sender,
                        sentAt: prev.sentAt,
                        readReceipt: to,
                        supportedStyle: prev.supportedStyle,
                        text: prev.text,
                        data: prev.data,
                        latitude: prev.latitude,
                        longitude: prev.longitude
                    )
                }
            }
        }
    }
}
