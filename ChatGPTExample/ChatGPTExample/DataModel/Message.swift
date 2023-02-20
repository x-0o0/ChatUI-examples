//
//  Message.swift
//  ChatGPTExample
//
//  Created by Jaesung Lee on 2023/02/21.
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
