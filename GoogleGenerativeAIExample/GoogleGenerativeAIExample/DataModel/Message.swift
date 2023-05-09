//
//  Message.swift
//  GoogleGenerativeAIExample
//
//  Created by Jaesung Lee on 2023/05/10.
//

import ChatUI
import Foundation

struct Message: MessageProtocol, Identifiable {
    var id: String
    var sentAt: Double
    var editedAt: Double?
    var readReceipt: ReadReceipt
    var style: MessageStyle
    var sender: User
}
