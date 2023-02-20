//
//  ChatView.swift
//  Quickstart
//
//  Created by Jaesung Lee on 2023/02/09.
//

import ChatUI
import SwiftUI

struct ChatView: View {
    /// The data model manages channel object and messages objects
    @StateObject private var dataModel = ChatModel()
    
    /// 6. `MessageField`: State property used in `MessageField/isMenuItemPresented`
    @State private var showsLocationSelector: Bool = false

    /// 2. How to change `Appearance`
    @Environment(\.appearance) var appearance
    
    var body: some View {
        /// 3. Provides `ChannelInfoView` internally. You use `VStack` instead.
        ChannelStack(ChatChannel.channel1) {
            /// 4. MessageList lists messages with `RowContent`
            MessageList(dataModel.messages) { message in
                /// 5. `MessageRow`: used in `MessageList/RowContent`
                VStack {
                    if message.readReceipt == .failed {
                        Text("Tap to delete")
                            .font(appearance.footnote)
                            .fontWeight(.semibold)
                            .foregroundColor(appearance.secondary)
                    }
                    
                    /// 5. `MessageRow`
                    MessageRow(
                        message: message,
                        showsUsername: false
                    )
                }
                .padding(.top, 12)
                /// 5. `MessageRow`: actions
                .onTapGesture(count: 1) {
                    guard message.readReceipt == .failed else { return }
                    withAnimation {
                        dataModel.messages
                            .removeAll { $0.id == message.id }
                    }
                }
                .onLongPressGesture {
                    guard message.readReceipt != .failed else { return }
                    withAnimation {
                        dataModel.messages
                            .removeAll { $0.id == message.id }
                    }
                }
            }
            
            Divider()
            
            ZStack(alignment: .bottom) {
                /// 6. `MessageField`
                MessageField(isMenuItemPresented: $showsLocationSelector) {
                    /// 6. `MessageField`: Send a new message
                    dataModel.sendMessage($0)
                }
                
                if showsLocationSelector {
                    /// 6. `MessageField`: shows `LocationSelector` when the menu is tapped.
                    LocationSelector(isPresented: $showsLocationSelector)
                }
            }
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView()
                /// 1. How to use `ChatConfiguration`
                .environmentObject(
                    ChatConfiguration(userID: ChatUser.user1.id)
                )
                /// 2. How to change `Appearance`
                .environment(\.appearance, Appearance(tint: .cyan))
        }
    }
}
