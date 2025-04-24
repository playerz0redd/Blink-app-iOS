//
//  PersonIconView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct PersonIconView: View {
    let nickname: String
    let size: CGFloat
    var fontSize: CGFloat = 20
    var body: some View {
        ZStack {
            Circle()
                .frame(width: size, height: size)
                .foregroundStyle(nickname.getColor())
                .overlay {
                    Text("\(nickname.first!)")
                        .font(.system(size: fontSize))
                        .bold()
                        .foregroundColor(.white)
                }
        }
    }
}
