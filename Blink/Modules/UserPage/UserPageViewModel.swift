//
//  UserPageViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 26.04.25.
//

import Foundation

class UserPageViewModel: ObservableObject {
    private let model = UserPageModel()
    @Published var userInfo: UserLocation?
    
    init(username: String) {
        Task {
            try await self.userInfo = getUserData(username: username)
        }
    }
    
    private func getUserData(username: String) async throws -> UserLocation? {
        if let userData = try await model.getUserInfo(username: username) {
            return .init(username: userData.friend_name,
                                  friendsSince: userData.friends_since,
                                  friendAmount: userData.friend_amount,
                                  location: .init(latitude: userData.lat,
                                                  longitude: userData.lng))
        }
        return nil
    }
    
    
    
    
}
