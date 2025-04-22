//
//  Model.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation

class MapWorkModel {
    
    private let storageService = StorageService()
    private let networkManager = NetworkManager2()
    
    func getFriendsLocation() async throws -> [Location]? {
        if let token = storageService.getToken() {
            let url = ApiURL.friendsLocation.rawValue + token
            let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager2.EmptyRequest())
            return try Response<[Location]>.parse(from: data!)
        }
        return nil
    }
    
    func updateMyLocation(latitude: Double, longitude: Double) async throws {
        if let token = storageService.getToken() {
            let locationUpdate = SocketLocationUpdateSend(type: .locationUpdate, token: token, latitude: latitude, longtitude: longitude)
            Task {
                //try await connectLocationSocket(to: .locationSocket)
                try await networkManager.sendDataSocket(data: locationUpdate)
            }
        }
    }
    
    func getPeopleVisited(name: String, method: MapService.ServerMethod) async throws -> Int {
        let data = try await networkManager.sendRequest(url: ApiURL.peopleVisited.rawValue + name,
                                                        method: .get,
                                                        requestData: NetworkManager2.EmptyRequest())
        
        guard let data = data else { return 0 }
        
        let peopleVisited : Int? = try Response.parse(from: data)
        if let amount = peopleVisited {
            return amount
        }
        return 0
    }
    
    func connectLocationSocket(to domain: ApiURL) async throws {
        if let token = storageService.getToken() {
            try await networkManager.connect(token: token, to: domain)
        }
    }
}
