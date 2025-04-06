//
//  Model.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation


class Model {
    
    var networkManager = NetworkManager()
    var storageService = StorageService()
    
    var username : String = ""
    var password : String = ""
    
    func getToken() -> String? {
        return storageService.getToken()
    }
    
    func userRegister() async throws -> String {
        let token = try await networkManager.userAuthorization(
            authorizationType: .registration,
            username: username,
            password: password
        )
        
        storageService.saveUserInfo(token: token, username: username, password: password)
        return token
    }
    
    func userLogin() async throws -> String {
        let token = try await networkManager.userAuthorization(authorizationType: .login,
                                                          username: username,
                                                          password: password)
        
        storageService.saveUserInfo(token: token, username: username, password: password)
        return token
    }
    
}
