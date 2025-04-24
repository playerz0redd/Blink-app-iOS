//
//  FriendsRecsView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 25.04.25.
//

import SwiftUI

struct FriendsRecsView: View {
    @StateObject var viewModel = FriendsViewModel()
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                HStack {
                    Text("recomended ")
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
            .padding(.horizontal, 15)
        }
    }
}

