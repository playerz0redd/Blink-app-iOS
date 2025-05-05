//
//  MessagesViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.05.25.
//

import Foundation
import Combine

struct MessagesDependency {
    var username: String
    var networkManager: NetworkManager2
}


class MessagesViewModel: ObservableObject {
    let model: MessagesModel
    @Published var chatWithUsername: String
    @Published var messages: [Message]?
    @Published var messageText: String = ""
    @Published var isUserPagePresented = false
    @Published var isPresentedSendButton: Bool = false
    private var cancellables = Set<AnyCancellable>()
    var myUsername: String
    @Published var messageSet: Set<UUID> = []
    
    init(dependency: MessagesDependency) {
        self.chatWithUsername = dependency.username
        self.model = .init(networkManager: dependency.networkManager)
        self.myUsername = model.getMyUsername() ?? ""
        
        Task {
            model.$newMessage
                .compactMap { $0 }
                .sink { [weak self] newMessage in
                    if let self = self {
                        messages?.append(newMessage)
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    @MainActor func sendMessage() {
        self.messageText = String(self.messageText.trimmingPrefix(while: \.isWhitespace))
        Task {
            try await model.sendMessage(text: messageText, to: chatWithUsername)
            self.messages?.append(.init(text: messageText, time: Date.now, usernameTo: chatWithUsername))
            self.messageText = ""
        }
    }
    
    @MainActor func getChatMessages() {
        Task {
            self.messages = try await model.getMessagesOfChat(with: self.chatWithUsername)
        }
    }
    
    func getSetOfMessagesWithDate() {
        self.messageSet = []
        guard let messages = self.messages, messages.count > 0 else { return }
        var messageSet: Set<UUID> = [messages[0].id]
        var currentDate = messages[0].time
        for message in messages {
            if message.time.getDeltaBetweenDates(to: currentDate) > 0 {
                currentDate = message.time
                messageSet.insert(message.id)
            }
        }
        self.messageSet =  messageSet
        
    }
}
