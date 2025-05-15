//
//  FriendsWorkViewModel.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation
import SwiftUI

class FriendsViewModel : ObservableObject {
    
    let model: FriendsWorkModel
    
    @Published var usernameToRequest: String = ""
    @Published var friendStatus: SearchPerson.Status = .friend
    @Published var peopleSearch: [SearchPerson] = []
    @Published var selectedUser: String = ""
    @Published var isPresented = false
    @Published var isPresentedMessages = false
    @Published var viewState: ViewState = .loading
    
    init(networkManager: NetworkManager) {
        self.model = .init(networkManager: networkManager)
    }
    
    func sendFriendRequest() async throws {
        try await model.sendFriendRequest(to: self.selectedUser)
    }
    
    @MainActor func getPeopleList() {
        self.viewState = .loading
        Task {
            do {
                self.peopleSearch = try await model.getPeopleByStatusList(status: self.friendStatus)
            } catch let error as ApiError {
                self.viewState = .error(error)
                return
            }
            self.viewState = .success
        }
    }
    
    @MainActor func findPeopleByUsername(username: String) {
        self.viewState = .loading
        Task {
            do {
                if let people = try await model.findPeopleByUsername(username: username) {
                    self.peopleSearch = people
                } else {
                    self.peopleSearch = []
                }
            } catch let error as ApiError {
                self.viewState = .error(error)
            }
            self.viewState = .success
        }
    }
    
    @MainActor func changeStatus() async throws {
        try await model.changeStatus(with: self.selectedUser, status: self.friendStatus)
    }
    
    func buttonChangeStatus(newStatus: SearchPerson.Status, with username: String, action: Action) {
        self.friendStatus = newStatus
        self.selectedUser = username
        Task {
            try await self.changeStatus()
        }
        if let index = self.peopleSearch.firstIndex(where: { $0.username == username }) {
            withAnimation {
                if action == .updateItem {
                    self.peopleSearch[index] = .init(username: username, status: newStatus)
                } else {
                    self.peopleSearch.remove(at: index)
                }
            }
        }
    }
    
    enum Action {
        case updateItem
        case deleteItem
    }

}
