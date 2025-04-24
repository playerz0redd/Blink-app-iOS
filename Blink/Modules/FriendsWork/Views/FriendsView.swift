//
//  FriendsView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 4.04.25.
//

import Foundation
import SwiftUI


struct FriendsView: View {
    @StateObject private var viewModel = FriendsViewModel()
    @FocusState private var isFocused: Bool
    @State private var isShowingBackground: Bool = false
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: UserLocation?
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Text(viewModel.usernameToRequest == "" ? "all friends " : "people found ")
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
        .onAppear {
            Task {
                viewModel.friendStatus = .friend
                try await viewModel.getPeopleList()
            }
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .padding(.leading, 10)
        
        FriendsSectionView(
            viewModel: viewModel,
            isShowingFriendInfoSheet: $isShowingFriendInfoSheet,
            selectedUser: $selectedUser
        )
        Spacer()
        searchField
    }
    
    
    var searchField: some View {
        TextField("", text: $viewModel.usernameToRequest, prompt: Text("search").bold().font(.system(size: 25)))
            .bold()
            .font(.system(size: 20))
            .padding(.leading, 16)
            .padding(.bottom, 30)
            .focused($isFocused)
            .onChange(of: isFocused) { newValue in
                withAnimation {
                    isShowingBackground = newValue
                }
            }
            .onSubmit({
                Task {
                    viewModel.peopleSearch = []
                    try await viewModel.findPeopleByUsername(username: viewModel.usernameToRequest)
                }
            })
            .background {
                if isShowingBackground {
                    LinearGradient(colors: [.purple, .pink], startPoint: .leading, endPoint: .trailing)
                        .cornerRadius(20)
                        .blur(radius: 30)
                        .transition(.opacity .combined(with: .scale))
                        .animation(.easeInOut(duration: 0.5), value: isShowingBackground)
                }
            }
            .background {
                RoundedRectangle(cornerRadius: 15)
                    .foregroundStyle(Color.dark)
                    .opacity(0.45)
                    .frame(height: 50)
                    .padding(.bottom, 27)
            }
            .padding(.horizontal, 10)
    }
}
