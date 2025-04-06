//
//  AuthorizationService.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation

class NetworkManager {

    // обработка кодов через throw
    
    let serverIP = "http://127.0.0.1:8000"
    
    public enum Authorization : String {
        case registration = "registration"
        case login = "login"
    }
    
    func userAuthorization(authorizationType : Authorization, username: String, password: String) async throws -> String {
        let userData = UserDataOut(username: username, password: password)
        let registrationURL = URL(string: serverIP + "/api/users/" + authorizationType.rawValue)
        
        guard let jsonData = try? JSONEncoder().encode(userData) else {
            print("error")
            return "Error"
        }
        
        var request = URLRequest(url: registrationURL!)
        request.httpMethod = "POST"
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let (data, response) = try await URLSession.shared.data(for: request)
    
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        let token = try JSONDecoder().decode(AuthResponse.self, from: data)
        print(token.token)
        return token.token
        
    }
    
}
