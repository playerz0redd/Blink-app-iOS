//
//  API-Entities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 17.04.25.
//

import Foundation

struct SearchPerson : Codable, Hashable, Equatable {
    
    var username : String
    var status : Status
    
    enum Status : String, Codable {
        case friend = "friend"
        case request = "request"
        case block = "block"
        case myRequest = "my_request"
        case unknown = "unknown"
    }
}
