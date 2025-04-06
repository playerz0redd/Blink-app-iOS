//
//  FriendsWorkModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation

class FriendsWorkModel {
    private let storageService = StorageService()
    private let mapNetworkService = FriendService()
    
    func sendFriendRequest(name : String) async throws {
        if let token = storageService.getToken() {
            try await mapNetworkService.sendRequest(token: token, name: name)
        }
    }

    func getPeopleByStatusList(status: FriendsInfoSend.Status) async throws -> Data {
        if let token = storageService.getToken() {
            return try await mapNetworkService.getPeopleList(token: token, status: status)
        }
        return Data()
    }
}
