//
//  ChatsViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import Foundation

struct ChatDependency {
    var networkManager: NetworkManager2
}

class ChatsViewModel: FriendsViewModel {
    @Published var myChats: [ChatItem]?
    @Published var isPresentedChat = false
    let chatModel: ChatsModel
    let maxMessageSize = 20
    
    init(dependency: ChatDependency) {
        self.chatModel = .init(networkManager: dependency.networkManager)
        super.init(networkManager: dependency.networkManager)
    }
    
    @MainActor func getMyChats() {
        Task {
            self.myChats = try await chatModel.getMyChats()
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
