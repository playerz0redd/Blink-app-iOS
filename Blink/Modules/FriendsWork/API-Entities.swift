//
//  API-Entities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 17.04.25.
//

import Foundation

struct SearchPerson : Codable {
    
    enum Status : String, Codable {
        case friend = "friend"
        case request = "request"
        case block = "block"
        case unknown = "unknown"
    }
    
    var username : String
    var status : Status
}
