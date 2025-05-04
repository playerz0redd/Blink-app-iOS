//
//  ViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation
import SwiftUI

@MainActor
class AuthViewModel : ObservableObject {
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var isLoading = false
    @Binding var isLogedIn: Bool
    
    var model = AuthModel()
    
    init(isLogedIn: Binding<Bool>) {
        self._isLogedIn = isLogedIn
    }
    
    func authefication(activity: Activity) async throws -> Bool {
        isLoading = true
        defer {
            isLoading = false
        }
        model.username = username
        model.password = password
        guard let token = try await model.userAuth(activity: activity) else { return false }
        model.saveUserInfo(username: username, password: password, token: token)
        return true
    }
    
    enum Activity {
        case authorization
        case registration
    }
    
}
