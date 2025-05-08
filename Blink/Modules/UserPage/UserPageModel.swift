//
//  UserPageModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 26.04.25.
//

import Foundation

class UserPageModel {
    let networkManager: NetworkManager
    let storageManager = StorageService()
    
    init(networkManager: NetworkManager) {
        self.networkManager = networkManager
    }
    
    func getUserInfo(username: String) async throws(ApiError) -> Location? {
        if let token = storageManager.getToken() {
            let data = try await networkManager.sendRequest(
                url: "\(ApiURL.userInfo.rawValue)\(token)/\(username)",
                method: .get,
                requestData: NetworkManager.EmptyRequest()
            )
            return try Response<Location>.parse(from: data!)
        }
        return nil
    }
    
    func changeStatus(with username: String, status: SearchPerson.Status) async throws(ApiError) {
        if let token = storageManager.getToken() {
            let url = ApiURL.friends.rawValue + token + "/" + status.rawValue + "/" + username
            try await networkManager.sendRequest(url: url, method: .put, requestData: NetworkManager.EmptyRequest())
        }
    }
    
    func getMyUsername() -> String? {
        storageManager.getUsername()
    }
}
