//
//  ChatsViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import Foundation

struct ChatDependency {
    var networkManager: NetworkManager
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
            self.viewState = .loading
            do {
                self.myChats = try await chatModel.getMyChats()
            } catch let error as ApiError {
                self.viewState = .error(error)
                return
            }
            if var chats = self.myChats {
                self.myChats = self.myChats?.sorted(by: { ($0.timeSent ?? .distantPast) > ($1.timeSent ?? .distantPast)})
                chats = self.myChats!
                for i in 0..<chats.count {
                    guard let message = self.myChats![i].lastMessage else { continue }
                    if message.count > maxMessageSize {
                        self.myChats![i].lastMessage = String(message.prefix(upTo: message.index(message.startIndex, offsetBy: maxMessageSize))) + "...."
                    }
                    
                }
            }
            self.viewState = .success
        }
    }
}
