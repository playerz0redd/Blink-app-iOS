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
    var user_name_from: String
    var user_name_to: String
    var time: Date
}
