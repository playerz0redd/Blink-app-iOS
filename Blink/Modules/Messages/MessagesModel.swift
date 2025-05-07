//
//  MessagesModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.05.25.
//

import Foundation
import SwiftUI

class MessagesModel: WebSocketDelegate {
    
    let networkManager: NetworkManager2
    private let storageManager = StorageService()
    @Published var newMessage: Message?
    @Published var updateMessages = false
    
    init(networkManager: NetworkManager2) {
        self.networkManager = networkManager
        self.networkManager.addDelegate(delegate: .init(delegate: self))
    }
    
    func sendMessage(text: String, to username: String) async throws {
        if let token = storageManager.getToken() {
            let message: Message = .init(text: text, time: Date.now, token: token, usernameTo: username, isRead: false)
            try await networkManager.sendDataSocket(data: message)
        }
    }
    
    func getMessagesOfChat(with username: String) async throws -> [Message]? {
        if let token = storageManager.getToken() {
            let url = ApiURL.chatItems.rawValue + token + "/" + username
            if let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager2.EmptyRequest()) {
                return try Response<[Message]>.parse(from: data)
            }
        }
        return nil
    }
    
    func readMessages(with username: String) async throws(ApiError) {
        if let token = storageManager.getToken() {
            try await networkManager.sendDataSocket(data: ReadMessages(
                token: token,
                usernameTo: username
            ))
        }
    }
    
    func didReceiveText(text: String) async throws(ApiError) {
        if let data = text.data(using: .utf8) {
            guard let messageType: SocketMessage = try Response.parse(from: data) else { return }
            
            if messageType.type == .chatMessage {
                guard let message: Message = try Response.parse(from: data) else { return }
                print("good")
                DispatchQueue.main.async {
                    print("------------обновляю @Published")
                    self.newMessage = Message(text: message.text, time: message.time, usernameTo: message.usernameTo, isRead: message.isRead)
                }
            }
            
            if messageType.type == .getUpdatedMessages {
                //guard let messages: [Message] = try Response.parse(from: data) else { return }
                print("good")
                DispatchQueue.main.async {
                    print("++++++++обновляю @Published")
                    self.updateMessages.toggle()
                }
            }
        }
    }
    
    func getMyUsername() -> String? {
        storageManager.getUsername()
    }
    
    
}
