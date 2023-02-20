//
//  QuickstartApp.swift
//  Quickstart
//
//  Created by Jaesung Lee on 2023/02/09.
//

import ChatUI
import SwiftUI

@main
struct QuickstartApp: App {
    /// 1. How to use `ChatConfiguration`
    @StateObject private var configuration = ChatConfiguration(
        userID: "andrew_parker",
        giphyKey: "wj5tEh9nAwNHVF3ZFavQ0zoaIyt8HZto"
    )
    
    var body: some Scene {
        WindowGroup {
            NavigationView {
                ChatView()
                    /// 1. How to use `ChatConfiguration`
                    .environmentObject(configuration)
            }
        }
    }
}
