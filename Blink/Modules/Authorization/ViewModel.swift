//
//  ViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation

@MainActor
class ViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var token: String = ""
    @Published var isLoading = false
    
    var model = Model()
    
    func registration() async throws {
        model.username = username
        model.password = password

        self.token = try await model.userRegister()
    }
    
    func login() async throws {
        isLoading = true
        defer {
            isLoading = false
        }
        model.username = username
        model.password = password
        
        self.token = try await model.userLogin()
    }
    
}
