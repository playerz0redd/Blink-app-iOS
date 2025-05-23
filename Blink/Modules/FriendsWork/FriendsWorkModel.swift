//
//  FriendsWorkModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation

class FriendsWorkModel {
    private let storageService = StorageService()
    let networkManager: NetworkManager
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func sendFriendRequest(to name: String) async throws(ApiError) {
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

    func getPeopleByStatusList(status: SearchPerson.Status) async throws(ApiError) -> [SearchPerson] {
        if let token = storageService.getToken() {
            let url = "\(ApiURL.friends.rawValue)\(token)/\(status.rawValue)"
            if let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager.EmptyRequest()) {
                return try Response<[SearchPerson]>.parse(from: data) ?? []
            }
        }
        return []
    }
    
    func findPeopleByUsername(username: String) async throws(ApiError) -> [SearchPerson]? {
        guard let token = storageService.getToken() else { return nil }
        
        let url = ApiURL.users.rawValue + username + "/" + token
        let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager.EmptyRequest())
        
        guard let data = data else { return nil }
        
        return try Response.parse(from: data)
    
    }
    
    func changeStatus(with username: String, status: SearchPerson.Status) async throws(ApiError) {
        if let token = storageService.getToken() {
            let url = ApiURL.friends.rawValue + token + "/" + status.rawValue + "/" + username
            try await networkManager.sendRequest(url: url, method: .put, requestData: NetworkManager.EmptyRequest())
        }
    }
}
