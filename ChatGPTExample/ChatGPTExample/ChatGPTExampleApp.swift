//
//  ChatGPTExampleApp.swift
//  ChatGPTExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import SwiftUI

@main
struct ChatGPTExampleApp: App {
    @StateObject private var configuration = ChatConfiguration(userID: User.me.id)
    let appearance = Appearance(
        tint: Color(red: 0, green: 166 / 255, blue: 126 / 255),
        localMessageBackground: Color(red: 0, green: 166 / 255, blue: 126 / 255)
    )
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ChatView()
                    .environmentObject(configuration)
                    .environment(\.appearance, appearance)
            }
        }
    }
}
