//
//  ChatGPT.swift
//  ChatGPTExample
//
//  Created by Jaesung Lee on 2023/02/21.
//

import ChatUI
import SwiftUI

/// This API key for free trial. So the chat may not work when it exceeds the daily usage.
/// - IMPORTANT: To use own API key is *neccessary*. You can see your API key from [https://platform.openai.com/account/api-keys](https://platform.openai.com/account/api-keys)
let apiKey = "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"
let chatbotAPIURL = URL(string: "https://api.openai.com/v1/completions")!

class ChatGPT: ObservableObject {
    @Published var messages: [Message] = []
    
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
            withAnimation {
                messages.insert(localMessage, at: 0)
            }
            /// Get response for ChatGPT
            requestResponse(for: text)
        default: return
        }
    }
    
    /// [API Reference](https://platform.openai.com/docs/api-reference/completions/create)
    func requestResponse(for text: String) {
        let headers = [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(apiKey)"
        ]
        
        let parameters = [
            "model": "text-davinci-003",
            "prompt": "\(text)\nAI:",
            "max_tokens": 100,
            "temperature": 0,
            "top_p": 1,
            "n": 1,
            "stream": false,
            "logprobs": nil,
            "stop": "\n:"
        ] as [String : Any?]
        guard let postData = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
            return
        }
        var request = URLRequest(url: chatbotAPIURL)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.httpBody = postData
        
        URLSession.shared.dataTask(with: request) { [self] data, response, error in
            if let data = data {
                if let responseText = String(data: data, encoding: .utf8) {
                    if let chatbotResponse = self.parseResponse(responseText) {
                        DispatchQueue.main.async {
                            let message = Message(
                                id: UUID().uuidString,
                                sentAt: Date().timeIntervalSince1970,
                                readReceipt: .seen,
                                style: .text(chatbotResponse),
                                sender: User.chatBot
                            )
                            withAnimation {
                                self.messages.insert(message, at: 0)                                
                            }
                        }
                    }
                }
            }
        }.resume()
        
    }
    
    func parseResponse(_ response: String) -> String? {
        let responseData = response.data(using: .utf8)!
        let json = try? JSONSerialization.jsonObject(with: responseData, options: []) as? [String: Any]
        let choices = json?["choices"] as? [[String: Any]]
        let text = choices?.first?["text"] as? String
        return text?.trimmingCharacters(in: .newlines)
    }
}


