//
//  API-URLs.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 16.04.25.
//

import Foundation

enum ApiURL: String {
    case login = "/api/users/login"
    case registration = "/api/users/registration"
    case friends = "/api/users/friendship/"
    case peopleVisited = "/api/users/friendship/visit/"
    case friendsLocation = "/api/users/friendship/location/"
    case users = "/api/users/"
    case updateMyLocation = "/api/users/location"
    case locationSocket = "/ws/connect/"
}
