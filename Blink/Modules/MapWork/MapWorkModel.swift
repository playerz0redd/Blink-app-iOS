//
//  Model.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation

class MapWorkModel {
    
    private let storageService = StorageService()
    private let mapNetworkService = MapService()
    
    func getFriendsLocation() async throws -> Data {
        
        if let token = storageService.getToken() {
            return try await mapNetworkService.getLocationList(token: token)
        }
        return Data()
    }
    
    func updateMyLocation(latitude: Double, longitude: Double) async throws {
        if let token = storageService.getToken() {
            try await mapNetworkService.updateMyLocation(token: token, latitude: latitude, longtitude: longitude)
        }
    }
    
    func getPeopleVisited(name: String, method: MapService.ServerMethod) async throws -> Int {
        let data = try await mapNetworkService.getPeopleVisitedAmount(friendName: name, method: method)
        if let amount = try? JSONDecoder().decode(ApiPeopleAmount.self, from: data) {
            return amount.people_visited
        }
        return 0
    }
}
