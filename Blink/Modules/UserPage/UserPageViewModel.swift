//
//  UserPageViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 26.04.25.
//

import Foundation
import CoreLocation

enum UserPageTerminationAction {
    case updateMapTarget(CLLocationCoordinate2D)
}

enum UserPageViewAction {
    case closeAndZoomOnUser
}

struct UserPageDependency {
    let username: String
    let onTerminate: (UserPageTerminationAction?) -> Void
}

final class UserPageViewModel: ObservableObject {
    
    private let dependency: UserPageDependency
    private let model = UserPageModel()
    var myUsername: String?
    
    @Published var userInfo: UserLocation?
    @Published var region: String?
    
    init(
        dependency: UserPageDependency
    ) {
        self.dependency = dependency
    }
    
    @MainActor
    func launch() async {
        guard let userData = try? await model.getUserInfo(
            username: dependency.username
        ) else { return }
        
        self.userInfo = .init(
            username: userData.friend_name,
            friendsSince: userData.friends_since,
            friendAmount: userData.friend_amount,
            location: .init(latitude: userData.lat,
                            longitude: userData.lng),
            peopleVisited: userData.people_visited
        )
        
        self.myUsername = model.getMyUsername()
        Task {
            try await self.region = userInfo?.location.getCity()
        }
    }
    
    func handle(viewAction: UserPageViewAction) {
        switch viewAction {
        case .closeAndZoomOnUser:
            guard let userInfo else {
                return dependency.onTerminate(nil)
            }
            dependency.onTerminate(.updateMapTarget(userInfo.location))
        }
    }
}
