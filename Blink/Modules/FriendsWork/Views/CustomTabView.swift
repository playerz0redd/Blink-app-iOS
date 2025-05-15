//
//  CustomTabView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = "ДРУЗЬЯ"
    private let tabNames = ["ДРУЗЬЯ", "ПРИГЛАШЕНИЯ"]
    @Namespace var animation
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: String
    var networkManager: NetworkManager
    
    init(isShowingFriendInfoSheet: Binding<Bool>, selectedUser: Binding<String>, networkManager: NetworkManager) {
        self._isShowingFriendInfoSheet = isShowingFriendInfoSheet
        self._selectedUser = selectedUser
        self.networkManager = networkManager
    }
    
    var body: some View {
        VStack {
            HStack(spacing: 0) {
                ForEach(tabNames, id: \.self) { tabName in
                    Button {
                        withAnimation(.spring()) {
                            selectedTab = tabName
                        }
                    } label: {
                        Text(tabName)
                            .padding(.trailing, 7)
                            .foregroundStyle(tabName == selectedTab ? Color.white : Color.gray)
                            .font(.system(size: 15))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .background {
                                if tabName == selectedTab {
                                    RoundedRectangle(cornerRadius: 12)
                                        .padding(8)
                                        .frame(height: 50)
                                        .foregroundStyle(Color.gray)
                                        .matchedGeometryEffect(id: "tab", in: animation)
                                }
                                
                            }
                    }
                    
                }
            }.frame(height: 50)
                .background {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundStyle(Color.black)
                }
                .padding(.horizontal, 10)
                .padding(.top, 30)
            
            Group {
                switch selectedTab {
                case "ДРУЗЬЯ":
                    FriendsView(isShowingFriendInfoSheet: $isShowingFriendInfoSheet, selectedUser: $selectedUser, networkManager: networkManager)
                case "ПРИГЛАШЕНИЯ":
                    RequestView(isShowingFriendInfoSheet: $isShowingFriendInfoSheet, selectedUser: $selectedUser, networkManager: networkManager)
                default:
                    FriendsView(isShowingFriendInfoSheet: $isShowingFriendInfoSheet, selectedUser: $selectedUser, networkManager: networkManager)
                }
                
            }.transition(.opacity)
            Spacer()
        }
    }
}
