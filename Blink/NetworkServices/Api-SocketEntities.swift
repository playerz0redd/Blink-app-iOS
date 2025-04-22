//
//  Api-SocketEntities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 22.04.25.
//

import Foundation



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
}

class SocketLocationUpdateSend: SocketMessage {
    let token: String?
    let latitude: Double
    let longitude: Double
    
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
    let id: Int
    
    init(username: String, id: Int, latitude: Double, longitude: Double) {
        self.username = username
        self.id = id
        super.init(latitude: latitude, longtitude: longitude)
    }
    
    enum CodingKeys: String, CodingKey {
        case username
        case id
        case latitude
        case longtitude
    }
    
    required init(from decoder: Decoder) throws {
        fatalError("init(from:) has not been implemented")
    }
    
    
}
