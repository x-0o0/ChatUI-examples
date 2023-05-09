//
//  GenerativeAI.swift
//  GoogleGenerativeAIExample
//
//  Created by Jaesung Lee on 2023/05/10.
//

import ChatUI
import SwiftUI
import Combine
import GoogleGenerativeAI

/// This API key for Google Generative AI SDK.
/// - IMPORTANT: To use own API key is *neccessary*. Please refer to the [link](https://platform.openai.com/account/api-keys)) to create your own API key.
/// - IMPORTANT: To use own API key is *neccessary*.
let apiKey = ""

/// **PaLM** (Pathways Language Model) is a 540 billion parameter transformer-based large language model developed by Google AI.
/// Please refer to [Google's examples](https://github.com/google/generative-ai-swift/blob/main/Examples/PaLMChat/PaLMChat/ViewModels/ConversationViewModel.swift)
@MainActor
class PaLM: ObservableObject {
    @Published var messages: [Message] = []
    
    var history: [GoogleGenerativeAI.Message] = []
    
    let client = GenerativeLanguage(apiKey: apiKey)
    
    var responsePublisher = PassthroughSubject<Message, Never>()
    
    func requestResponse(with text: String) async throws {
        var response: GenerateMessageResponse
        if history.isEmpty {
            // this is the user's first message
            response = try await client.chat(message: text)
        } else {
            // send previous chat messages *and* the user's new message to the backend
            response = try await client.chat(message: text, history: history)
        }
        
        if let candidate = response.candidates?.first, let text = candidate.content {
            let message = Message(
                id: UUID().uuidString,
                sentAt: Date().timeIntervalSince1970,
                readReceipt: .seen,
                style: .text(text),
                sender: User.chatBot
            )
            insertMessage(message)
            
            if let historicMessages = response.messages {
                history = historicMessages
                history.append(candidate)
            }
        }
    }
    
    func sendMesssage(forStyle style: MessageStyle) {
        switch style {
        case .text(let text):
            let localMessage = Message(
                id: UUID().uuidString,
                sentAt: Date().timeIntervalSince1970,
                readReceipt: .seen,
                style: style,
                sender: User.me
            )
            insertMessage(localMessage)
            /// Get response for ChatGPT
            Task {
                try await requestResponse(with: text)
                
            }
        default: return
        }
    }
    
    func insertMessage(_ message: Message) {
        withAnimation {
            self.messages.insert(message, at: 0)
        }
    }
}
