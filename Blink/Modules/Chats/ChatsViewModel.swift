//
//  ChatsViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import Foundation


class ChatsViewModel: FriendsViewModel {
    @Published var myChats: [ChatItem]?
    private let model = ChatsModel()
    let maxMessageSize = 20
    
    @MainActor func getMyChats() {
        Task {
            self.myChats = try await model.getMyChats()
            if let chats = self.myChats {
                for i in 0..<chats.count {
                    guard let message = self.myChats![i].lastMessage else { continue }
                    if message.count > maxMessageSize {
                        self.myChats![i].lastMessage = String(message.prefix(upTo: message.index(message.startIndex, offsetBy: maxMessageSize))) + "...."
                    }
                    
                }
            }
        }
    }
    
}
