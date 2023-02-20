//
//  FirebaseExampleApp.swift
//  FirebaseExample
//
//  Created by Jaesung Lee on 2023/02/16.
//

import ChatUI
import SwiftUI
import Firebase

@main
struct FirebaseExampleApp: App {
    @StateObject private var configuration = ChatConfiguration(
        userID: User.me.id,
        giphyKey: "wj5tEh9nAwNHVF3ZFavQ0zoaIyt8HZto"
    )
    
    let appearance = Appearance(
        tint: Color(red: 1, green: 160 / 255, blue: 0),
        localMessageBackground: Color(red: 1, green: 160 / 255, blue: 0),
        remoteMessageBackground: Color(red: 236 / 255, green: 239 / 255, blue: 241 / 255)
    )
    
    var body: some Scene {
        WindowGroup {
            ChatView()
                .environmentObject(configuration)
                .environment(\.appearance, appearance)
        }
    }
    
    init() {
        FirebaseApp.configure()
    }
}
