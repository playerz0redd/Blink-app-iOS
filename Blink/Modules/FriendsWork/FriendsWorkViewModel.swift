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
    @Published var peopleSearch : [SearchPerson]?
    
    func sendFriendRequest() async throws {
        try await model.sendFriendRequest(name: self.requestName)
    }
    
    func getPeopleList() async throws {
        let undecodedData = try await model.getPeopleByStatusList(status: self.friendStatus)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        self.friendsInfoArray = try decoder.decode([PeopleInfoResult].self, from: undecodedData)
    }
    
    func findPeopleByUsername(username: String) async throws {
        self.peopleSearch = try await model.findPeopleByUsername(username: username)
    }
    
    enum FriendStatus {
        case friend
        case request
        case block
    }
}
