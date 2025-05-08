//
//  API-Entities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.04.25.
//

import Foundation

struct UserDataOut: Codable {
    var username: String
    var password: String
}

struct AuthResponse : Codable {
    var token: String
}
