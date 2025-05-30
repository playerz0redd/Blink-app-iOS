//
//  ChatsModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.05.25.
//

import Foundation

class ChatsModel {
    let networkManager: NetworkManager
    private let storageManager = StorageService()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getMyChats() async throws(ApiError) -> [ChatItem]? {
        if let token = storageManager.getToken() {
            guard let data = try await networkManager.sendRequest(
                url: "\(ApiURL.chatItems.rawValue)\(token)",
                method: .get,
                requestData: NetworkManager.EmptyRequest()
            ) else { return nil }
            
            if let chatItems = try Response<[ChatItem]>.parse(from: data) {
                return chatItems
            }
        }
        return nil
    }
    
    
}
