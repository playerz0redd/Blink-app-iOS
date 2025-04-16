//
//  API-FriendEntities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation


struct FriendsInfoSend : Codable {
    
    enum Status : String, Codable {
        case friend
        case request
        case block
    }
    
    var userFromToken: String
    var userToName: String
    var time: String
    var status: Status
}

struct PeopleInfoResult : Codable {
    var usernameFrom: String
    var usernameTo: String
    var time: Date
    
    enum CodingKeys: String, CodingKey {
        case usernameFrom = "user_name_from"
        case usernameTo = "user_name_to"
        case time
    }
}
