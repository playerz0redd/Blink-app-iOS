//
//  Api-SocketEntities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 22.04.25.
//

import Foundation
import CoreLocation



class SocketMessage: Codable {
    
    enum MessageType: String, Codable {
        case locationUpdate = "locationUpdate"
        case chatMessage = "chatMessage"
    }
    
    let type: MessageType?
    
    init(type: MessageType) {
        self.type = type
    }
    
    init() {
        self.type = nil
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.type = try container.decodeIfPresent(SocketMessage.MessageType.self, forKey: .type)
    }
}

class SocketLocationUpdateSend: SocketMessage {
    
    let token: String?
    var latitude: Double
    var longitude: Double
    
    init(type: SocketMessage.MessageType, token: String, latitude: Double, longtitude: Double) {
        self.latitude = latitude
        self.longitude = longtitude
        self.token = token
        super.init(type: type)
    }
    
    init(latitude: Double, longtitude: Double) {
        self.latitude = latitude
        self.longitude = longtitude
        self.token = nil
        super.init()
    }
    
    enum CodingKeys: String, CodingKey {
        case token
        case latitude
        case longitude
        case type
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        token = try container.decode(String.self, forKey: .token)
        latitude = try container.decode(Double.self, forKey: .latitude)
        longitude = try container.decode(Double.self, forKey: .longitude)
        let type = try container.decode(SocketMessage.MessageType.self, forKey: .type)
        super.init(type: type)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(token, forKey: .token)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
        try container.encode(type, forKey: .type)
    }
}


class LocationUpdateGet: SocketLocationUpdateSend {
    
    let username: String
    
    init(username: String, latitude: Double, longitude: Double) {
        self.username = username
        super.init(latitude: latitude, longtitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case latitude
        case longitude
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        username = try container.decode(String.self, forKey: .username)
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        super.init(latitude: latitude, longtitude: longitude)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(username, forKey: .username)
        try container.encode(latitude, forKey: .latitude)
        try container.encode(longitude, forKey: .longitude)
    }
}

struct UserLocation: Identifiable {
    var id = UUID()
    var username : String
    var friendsSince: Date?
    var friendAmount : Int?
    var location: CLLocationCoordinate2D
    
    init(username: String, location: CLLocationCoordinate2D) {
        self.username = username
        self.location = location
    }
    
    init(username: String, friendsSince: Date, friendAmount: Int, location: CLLocationCoordinate2D) {
        self.friendsSince = friendsSince
        self.friendAmount = friendAmount
        self.username = username
        self.location = location
    }
}
