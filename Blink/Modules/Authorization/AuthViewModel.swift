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
    @Binding var isLogedIn: Bool
    @Published var errorState = ErrorState()
    
    var model = AuthModel()
    
    init(isLogedIn: Binding<Bool>) {
        self._isLogedIn = isLogedIn
    }
    
    func checkAllFieldsAreFilled() -> Bool {
        if self.username == "" || self.password == "" {
            self.errorState.setError(error: ApiError.appError(.notAllFieldsFilled))
            return false
        }
        return true
    }
    
    func authefication(activity: Activity) async -> Bool {
        var token: String?
        do {
            token = try await model.userAuth(activity: activity, username: self.username, password: self.password)
        } catch let error {
            errorState.setError(error: error)
        }
        guard let token = token else { return false }
        model.saveUserInfo(username: username, password: password, token: token)
        return true
    }
    
    enum Activity {
        case authorization
        case registration
    }
    
}
