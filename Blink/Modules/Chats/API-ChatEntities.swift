//
//  API-Entities.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 2.05.25.
//

import Foundation


struct ChatItem: Codable, Equatable, Comparable {
    static func < (lhs: ChatItem, rhs: ChatItem) -> Bool {
        lhs.timeSent ?? Date() < rhs.timeSent ?? Date()
    }
    
    var username: String
    var lastMessage: String?
    var usernameSent: String?
    var timeSent: Date?
    
    enum CodingKeys: String, CodingKey {
        case username = "username"
        case lastMessage = "last_message"
        case usernameSent = "username_sent"
        case timeSent = "time_sent"
    }
}
