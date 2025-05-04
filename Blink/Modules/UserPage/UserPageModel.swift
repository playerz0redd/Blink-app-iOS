//
//  UserPageModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 26.04.25.
//

import Foundation

class UserPageModel {
    let networkManager = NetworkManager2()
    let storageManager = StorageService()
    
    func getUserInfo(username: String) async throws(ApiError) -> Location? {
        if let token = storageManager.getToken() {
            let data = try await networkManager.sendRequest(
                url: "\(ApiURL.userInfo.rawValue)\(token)/\(username)",
                method: .get,
                requestData: NetworkManager2.EmptyRequest()
            )
            return try Response<Location>.parse(from: data!)
        }
        return nil
    }
    
    func getMyUsername() -> String? {
        storageManager.getUsername()
    }
}
