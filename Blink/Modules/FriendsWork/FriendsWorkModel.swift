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
    let networkManager: NetworkManager2
    
    init(networkManager: NetworkManager2) {
        self.networkManager = networkManager
    }
    
    func sendFriendRequest(to name: String) async throws {
        if let token = storageService.getToken() {
            let dateFormatter = ISO8601DateFormatter()
            dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
            
            try await networkManager.sendRequest(
                url: ApiURL.friends.rawValue,
                method: .post,
                requestData: FriendsInfoSend(
                    userFromToken: token,
                    userToName: name,
                    time: dateFormatter.string(from: Date()),
                    status: .request)
            )
        }
    }

    func getPeopleByStatusList(status: SearchPerson.Status) async throws -> [SearchPerson] {
        if let token = storageService.getToken() {
            let url = "\(ApiURL.friends.rawValue)\(token)/\(status.rawValue)"
            if let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager2.EmptyRequest()) {
                return try Response<[SearchPerson]>.parse(from: data) ?? []
            }
        }
        return []
    }
    
    func findPeopleByUsername(username: String) async throws -> [SearchPerson]? {
        guard let token = storageService.getToken() else { return nil }
        
        let url = ApiURL.users.rawValue + username + "/" + token
        let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager2.EmptyRequest())
        
        guard let data = data else { return nil }
        
        return try Response.parse(from: data)
    
    }
    
    func changeStatus(with username: String, status: SearchPerson.Status) async throws(ApiError) {
        if let token = storageService.getToken() {
            let url = ApiURL.friends.rawValue + token + "/" + status.rawValue + "/" + username
            try await networkManager.sendRequest(url: url, method: .put, requestData: NetworkManager2.EmptyRequest())
        }
    }
}
