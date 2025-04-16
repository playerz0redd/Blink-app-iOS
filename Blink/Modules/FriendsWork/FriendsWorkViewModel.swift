//
//  FriendsWorkViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation

class FriendsViewModel : ObservableObject {
    
    private let model = FriendsWorkModel()
    
    @Published var requestName: String = ""
    @Published var friendStatus: FriendsInfoSend.Status = .friend
    @Published var friendsInfoArray: [PeopleInfoResult] = []
    
    func sendFriendRequest() async throws {
        try await model.sendFriendRequest(name: self.requestName)
    }
    
    func getPeopleList() async throws {
        let undecodedData = try await model.getPeopleByStatusList(status: self.friendStatus)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.friendsInfoArray = try decoder.decode([PeopleInfoResult].self, from: undecodedData)
    }
    
    enum FriendStatus {
        case friend
        case request
        case block
    }
}
