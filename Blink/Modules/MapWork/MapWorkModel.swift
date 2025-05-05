//
//  Model.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation
import SwiftUI

class MapWorkModel: WebSocketDelegate, ObservableObject {

    private let storageService = StorageService()
    let networkManager : NetworkManager2
    @Published var locationUpdate: UserLocation?
    private let healthManager = HealthManager()
    
    func didReceiveText(text: String) async throws(ApiError) {
        if let data = text.data(using: .utf8) {
            guard let message: SocketMessage = try Response.parse(from: data) else { return }
            
            if message.type == .locationUpdate {
                guard let location: LocationUpdateGet = try Response.parse(from: data) else { return }
                DispatchQueue.main.async {
                    self.locationUpdate = UserLocation(
                        username: location.username,
                        location: .init(latitude: location.latitude, longitude: location.longitude)
                    )
                }
            }
        }
    }
    
    init(networkManager: NetworkManager2) {
        self.networkManager = networkManager
        self.networkManager.addDelegate(delegate: .init(delegate: self))
        Task {
            try await self.networkManager.startListening()
        }
    }
    
    func getFriendsLocation() async throws(ApiError) -> [Location]? {
        if let token = storageService.getToken() {
            let url = ApiURL.friendsLocation.rawValue + token
            let data = try await networkManager.sendRequest(url: url, method: .get, requestData: NetworkManager2.EmptyRequest())
            return try Response<[Location]>.parse(from: data!)
        }
        return nil
    }
    
    func updateMyLocation(latitude: Double, longitude: Double) async throws(ApiError) {
        if let token = storageService.getToken() {
            let locationUpdate = SocketLocationUpdateSend(type: .locationUpdate, token: token, latitude: latitude, longtitude: longitude)
            try await networkManager.sendDataSocket(data: locationUpdate)
        }
    }
    
    func getPeopleVisited(name: String, method: NetworkManager2.RequestMethod) async throws(ApiError) -> Int {
        let data = try await networkManager.sendRequest(
            url: ApiURL.peopleVisited.rawValue + name,
            method: method,
            requestData: NetworkManager2.EmptyRequest()
        )
        
        guard let data = data else { return 0 }
        
        let peopleVisited : Int? = try Response.parse(from: data)
        if let amount = peopleVisited {
            return amount
        }
        return 0
    }
    
    func connectLocationSocket(to domain: ApiURL) async throws(ApiError) {
        if let token = storageService.getToken() {
            try await networkManager.connect(token: token, to: domain)
        }
    }
    
    func getMyUsername() -> String? {
        storageService.getUsername()
    }

}
