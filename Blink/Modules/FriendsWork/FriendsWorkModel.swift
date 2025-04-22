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
    private let networkManager = NetworkManager2()
    
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
    
    func findPeopleByUsername(username: String) async throws -> [SearchPerson]? {
        
        guard let token = storageService.getToken() else { return nil }
        
        let url = ApiURL.users.rawValue + username + "/" + token
        let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager2.EmptyRequest())
        
        guard let data = data else { return nil }
        
        return try Response.parse(from: data)
    
    }
}
