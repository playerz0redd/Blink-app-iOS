//
//  CustomTabView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct CustomTabView: View {
    @State private var selectedTab = "FRIENDS"
    private let tabNames = ["FRIENDS", "REQUESTS"]
    @Namespace var animation
    @Binding var isShowingFriendInfoSheet: Bool
    @Binding var selectedUser: UserLocation?
    var body: some View {
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
            case "FRIENDS":
                FriendsView(isShowingFriendInfoSheet: $isShowingFriendInfoSheet, selectedUser: $selectedUser)
            case "REQUESTS":
                RequestView(isShowingFriendInfoSheet: $isShowingFriendInfoSheet, selectedUser: $selectedUser)
            default:
                MapView()
            }
            
        }.transition(.opacity)
    }
}
