//
//  RequestView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct RequestView: View {
    @StateObject private var viewModel = FriendsViewModel()
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: String//UserLocation?
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("all requests ")
                        .bold()
                        .font(.largeTitle)
                    +
                    Text("\(viewModel.peopleSearch.count)")
                        .foregroundStyle(Color .gray)
                        .bold()
                        .font(.system(size: 30))
                        .font(.caption)
                }
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)
            .padding(.leading, 10)
            
            FriendsSectionView(
                viewModel: viewModel,
                isShowingFriendInfoSheet: $isShowingFriendInfoSheet,
                selectedUser: $selectedUser
            )
        }.onAppear() {
            Task {
                viewModel.friendStatus = .request
                try await viewModel.getPeopleList()
            }
        }
    }
}

