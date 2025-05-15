//
//  StorageService.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation

class StorageService {
    private let storage = UserDefaults.standard
    
    func saveUserInfo(token : String, username: String, password: String) {
        storage.set(username, forKey: "username")
        storage.set(password, forKey: "password")
        storage.set(token, forKey: "token")
    }
    
    func getToken() -> String? {
        storage.string(forKey: "token")
    }
    
    func saveMapStyle(mapStyle: Any) {
        storage.set(mapStyle, forKey: "mapStyle")
    }
    
    func getMapStyle() -> Any? {
        storage.object(forKey: "mapStyle")
    }
    
    func getUsername() -> String? {
        return storage.string(forKey: "username")
    }
    
    func getPassword() -> String? {
        return storage.string(forKey: "password")
    }
    
    func deleteUser() {
        storage.removeObject(forKey: "username")
        storage.removeObject(forKey: "password")
        storage.removeObject(forKey: "token")
    }
}
