//
//  MainViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 6.04.25.
//

import Foundation

class MainViewModel : ObservableObject {
    @Published var isLogedIn: Bool = false
    
    private let storageService = StorageService()
    
    func checkLogedIn() {
        self.isLogedIn = storageService.getToken() != nil
    }
    
    
}
