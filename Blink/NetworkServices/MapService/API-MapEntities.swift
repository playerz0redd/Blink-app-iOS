//
//  API-Entities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.04.25.
//

import Foundation
import CoreLocation

struct Location : Codable {
    var friend_name: String
    var friend_amount: Int
    var people_visited: Int
    var friends_since: Date?
    var lat: Double
    var lng: Double
}

struct MyLocationUpdate : Codable {
    var user_token: String
    var lat: Double
    var lng: Double
}

struct ApiPeopleAmount : Codable {
    var peopleVisitedAmount: Int
    
    enum CodingKeys: String, CodingKey {
        case peopleVisitedAmount = "people_visited"
    }
}

