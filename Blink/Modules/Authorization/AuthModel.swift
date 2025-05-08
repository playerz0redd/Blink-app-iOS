//
//  Model.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation


class AuthModel {
    
    private var networkManager = NetworkManager()
    private var storageService = StorageService()
    
    func getToken() -> String? {
        return storageService.getToken()
    }
    
    func saveUserInfo(username: String, password: String, token: String) {
        storageService.saveUserInfo(token: token, username: username, password: password)
    }
    
    func userAuth(
        activity: AuthViewModel.Activity,
        username: String,
        password: String
    ) async throws(ApiError) -> String? {
        let tokenData = try await networkManager.sendRequest(
            url: activity == .authorization ? ApiURL.login.rawValue : ApiURL.registration.rawValue,
            method: .post,
            requestData: UserDataOut(username: username, password: password)
        )
        
        let token: String? = try Response.parse(from: tokenData!)
        return token
    }
    
}
