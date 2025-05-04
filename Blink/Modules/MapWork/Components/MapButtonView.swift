//
//  MapButtonView.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 24.04.25.
//

import SwiftUI

struct MapButtonView: View {
    let imageName: String
    let imageSize: CGFloat
    let rectangleWidth: CGFloat
    let rectangleHeight: CGFloat
    
    var body: some View {
        Image(systemName: imageName)
            .font(.system(size: imageSize))// 35 for center, 27
            .foregroundStyle(Color.white)
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .frame(width: rectangleWidth, height: rectangleHeight) // 70,85 for center, 60,75
                    .foregroundStyle(Color("dark"))
                    .opacity(0.7)
            }
    }
}
