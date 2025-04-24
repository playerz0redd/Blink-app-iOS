//
//  FriendsActionButton.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct FriendsActionButton: View {
    var leftColor: Color
    var rightColor: Color
    var imagePath: String
    var completion: () -> Void
    var body: some View {
        Button {
            completion()
        } label: {
            Image(systemName: imagePath)
                .font(.system(size: 20))
                .foregroundStyle(Color.black)
                .background {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 43, height: 35)
                        .foregroundStyle(LinearGradient(
                            colors: [leftColor, rightColor],
                            startPoint: .leading,
                            endPoint: .trailing)
                        )
                }
        }

    }
}
