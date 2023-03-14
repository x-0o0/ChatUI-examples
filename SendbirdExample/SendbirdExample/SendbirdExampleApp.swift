//
//  SendbirdExampleApp.swift
//  SendbirdExample
//
//  Created by Jaesung Lee on 2023/03/10.
//

import ChatUI
import SwiftUI

@main
struct SendbirdExampleApp: App {
    @StateObject var config = ChatConfiguration(userID: User.me.id)
    
    let appearance = Appearance(
        tint: Color(red: 116 / 255, green: 45 / 255, blue: 221 / 255),
        localMessageBackground: Color(red: 116 / 255, green: 45 / 255, blue: 221 / 255),
        remoteMessageBackground: Color(red: 238 / 255, green: 238 / 255, blue: 238 / 255),
        link: Color(red: 116 / 255, green: 45 / 255, blue: 221 / 255),
        prominentLink: Color(red: 255 / 255, green: 242 / 255, blue: 182 / 255)
    )
    var body: some Scene {
        WindowGroup {
            NavigationView {
                OpenChatView()
                    .environmentObject(config)
                    .environment(\.appearance, appearance)
            }
        }
    }
}
