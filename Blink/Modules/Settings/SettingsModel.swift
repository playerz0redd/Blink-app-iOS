//
//  SettingsModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.05.25.
//

import Foundation

class SettingsModel {
    private let storageManager = StorageService()
    
    func logout() {
        storageManager.deleteUser()
    }
    
    func saveMapStyle(mapStyle: Any) {
        storageManager.saveMapStyle(mapStyle: mapStyle)
    }
    
    func getMapStyle() -> Any? {
        storageManager.getMapStyle()
    }
}
