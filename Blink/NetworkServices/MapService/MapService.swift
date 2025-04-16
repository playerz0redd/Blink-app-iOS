//
//  MapNetworkService.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation

class MapService {
    
    enum ServerMethod: String {
        case get = "GET"
        case post = "POST"
    }
    
    let serverIP = "http://127.0.0.1:8000"
    
    func getLocationList(token: String) async throws -> Data {
        let requestLink = URL(string: serverIP + "/api/users/friendship/location/\(token)")
        
        var request = URLRequest(url: requestLink!)
        request.httpMethod = "GET"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        print(String(data: data, encoding: .utf8) ?? "No data")
        
        return data
    }
    
    func updateMyLocation(token: String, latitude: Double, longtitude: Double) async throws {
        let requestLink = URL(string: serverIP + "/api/users/location")
        
        let locationData = MyLocationUpdate(user_token: token, lat: latitude, lng: longtitude)
        
        if let jsonData = try? JSONEncoder().encode(locationData) {
            print(String(data: jsonData, encoding: .utf8) ?? "No data")
        }
        
        var request = URLRequest(url: requestLink!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
    }
    
    func getPeopleVisitedAmount(friendName: String, method: ServerMethod) async throws -> Data {
        let requestLink = URL(string: serverIP + "/api/users/friendship/visit/" + friendName)
        
        var request = URLRequest(url: requestLink!)
        request.httpMethod = method.rawValue
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        if let httpResponse = response as? HTTPURLResponse {
            print(httpResponse.statusCode)
        }
        
        return data
        
        
    }
    
}
