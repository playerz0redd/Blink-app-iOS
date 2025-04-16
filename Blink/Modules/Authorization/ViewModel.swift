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
    
    func authefication(isLoged : Bool, activity: Activity) async throws -> Bool {
        isLoading = true
        defer {
            isLoading = false
        }
        model.username = username
        model.password = password
        
        do {
            self.token = try await model.userAuth(activity: activity)
        } catch let error as ApiError {
            print(error.returnErrorMessage())
        }
        return self.token == "" ? false : true
    }
    
    enum Activity {
        case authorization
        case registration
    }
    
}
