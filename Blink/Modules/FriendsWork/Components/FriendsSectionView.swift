//
//  FriendsSectionView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import SwiftUI

struct FriendsSectionView: View {
    @StateObject var viewModel: FriendsViewModel
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: UserLocation?
    var body: some View {
        VStack {
            ScrollView {
                ForEach(viewModel.peopleSearch, id: \.self.username) { friend in
                    HStack(spacing: 15) {
                        Button {
                            selectedUser = .init(username: friend.username, friendsSince: Date(), friendAmount: 0, location: .init(latitude: 10, longitude: 10))
                            isShowingFriendInfoSheet.toggle()
                        } label: {
                            PersonIconView(nickname: friend.username, size: 35)
                            
                            Text("\(friend.username)")
                                .bold()
                                .foregroundStyle(Color.black)
                            
                            Spacer()
                        }
                        
                        switch friend.status {
                        case .friend:
                            HStack(spacing: 27) {
                                FriendsActionButton(
                                    leftColor: .blue,
                                    rightColor: .purple,
                                    imagePath: "captions.bubble.fill") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .friend,
                                            with: friend.username,
                                            action: .updateItem
                                        )
                                    }
                                
                                FriendsActionButton(
                                    leftColor: .purple,
                                    rightColor: .pink,
                                    imagePath: "location.fill") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .unknown,
                                            with: friend.username,
                                            action: .deleteItem
                                        )
                                    }
                            }
                        case .request:
                            HStack(spacing: 27) {
                                FriendsActionButton(
                                    leftColor: .blue,
                                    rightColor: .purple,
                                    imagePath: "person.crop.circle.badge.checkmark") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .friend,
                                            with: friend.username,
                                            action: .updateItem
                                        )
                                    }
                                
                                FriendsActionButton(
                                    leftColor: .purple,
                                    rightColor: .pink,
                                    imagePath: "person.crop.circle.badge.xmark") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .unknown,
                                            with: friend.username,
                                            action: .deleteItem
                                        )
                                    }
                            }
                            
                        case .block:
                            Text("blocked")
                                .bold()
                        case .myRequest:
                            HStack(spacing: 27) {
                                Text("sent")
                                    .bold()
                                    .foregroundStyle(LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing))
                                
                                FriendsActionButton(
                                    leftColor: .purple,
                                    rightColor: .pink,
                                    imagePath: "person.crop.circle.badge.xmark") {
                                        viewModel.buttonChangeStatus(
                                            newStatus: .unknown,
                                            with: friend.username,
                                            action: .deleteItem
                                        )
                                    }
                            }
                        case .unknown:
                            FriendsActionButton(
                                leftColor: .purple,
                                rightColor: .pink,
                                imagePath: "person.fill.badge.plus") {
                                    viewModel.buttonChangeStatus(
                                        newStatus: .myRequest,
                                        with: friend.username,
                                        action: .updateItem
                                    )
                                }
                        }
                        
                    }.padding(.horizontal, 15)
                }
                if viewModel.peopleSearch == [] {
                    Text("we're not even sure\nwho to recommend...")
                        .font(.title)
                        .bold()
                        .padding(.top, 70)
                }
            }
        }
    }
}
