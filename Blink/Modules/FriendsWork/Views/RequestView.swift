//
//  RequestView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct RequestView: View {
    @StateObject private var viewModel: FriendsViewModel
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: String
    
    init(isShowingFriendInfoSheet: Binding<Bool>, selectedUser: Binding<String>, networkManager: NetworkManager) {
        self._isShowingFriendInfoSheet = isShowingFriendInfoSheet
        self._selectedUser = selectedUser
        _viewModel = .init(wrappedValue: .init(networkManager: networkManager))
    }
    
    var body: some View {
        VStack {
            switch viewModel.viewState {
            case .loading:
                ProgressView {
                    Text("Загрузка")
                        .font(.system(size: 23, weight: .medium))
                        .foregroundStyle(.black)
                }
                .padding(.top, 140)
                .transition(.opacity)
            case .error(let apiError):
                Text("\(apiError.returnErrorMessage())")
                    .font(.system(size: 23, weight: .medium))
                    .foregroundStyle(.black)
                    .transition(.opacity)
                    .padding(.top, 140)
            case .success:
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
                        selectedUser: $selectedUser
                    )
                }.transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: viewModel.viewState)
        .onAppear() {
            viewModel.friendStatus = .request
            viewModel.getPeopleList()
        }
    }
}

