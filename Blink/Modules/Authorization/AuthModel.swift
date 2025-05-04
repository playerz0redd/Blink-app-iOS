//
//  Model.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation


class AuthModel {
    
    private var networkManager = NetworkManager2()
    private var storageService = StorageService()
    
    var username : String = ""
    var password : String = ""
    
    func getToken() -> String? {
        return storageService.getToken()
    }
    
    func saveUserInfo(username: String, password: String, token: String) {
        storageService.saveUserInfo(token: token, username: username, password: password)
    }
    
    func userAuth(activity: AuthViewModel.Activity) async throws -> String? {
        var tokenData = try await networkManager.sendRequest(
            url: activity == .authorization ? ApiURL.login.rawValue : ApiURL.registration.rawValue,
            method: .post,
            requestData: UserDataOut(username: username, password: password)
        )
        let token: String? = try Response.parse(from: tokenData!)
        return token
    }
    
}
