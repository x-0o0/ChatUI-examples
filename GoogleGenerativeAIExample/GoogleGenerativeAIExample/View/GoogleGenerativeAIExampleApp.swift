//
//  GoogleGenerativeAIExampleApp.swift
//  GoogleGenerativeAIExample
//
//  Created by Jaesung Lee on 2023/05/10.
//

import ChatUI
import SwiftUI

@main
struct GoogleGenerativeAIExampleApp: App {
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
