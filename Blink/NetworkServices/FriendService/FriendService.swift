//
//  FriendService.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation

class FriendService {
    
    let serverIP = "http://127.0.0.1:8000"
    
    func sendRequest(token: String, name: String) async throws {
        let dateFormatter = ISO8601DateFormatter()
        dateFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        let requestData = FriendsInfoSend(userFromToken: token, userToName: name, time: dateFormatter.string(from: Date()), status: .friend)
        let registrationURL = URL(string: serverIP + "/api/users/friendship")
        
        guard let jsonData = try? JSONEncoder().encode(requestData) else {
            print("JSON convert error")
            return
        }
        print(String(data: jsonData, encoding: .utf8)!)
        
        var request = URLRequest(url: registrationURL!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        print(String(data: data, encoding: .utf8) ?? "No data")
    }
    
    func getPeopleList(token: String, status: FriendsInfoSend.Status) async throws -> Data {
        let requestLink = URL(string: serverIP + "/api/users/friendship/\(token)/\(status.rawValue)")
        
        var request = URLRequest(url: requestLink!)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        print(String(data: data, encoding: .utf8) ?? "No data")
        
        return data
    }
}
