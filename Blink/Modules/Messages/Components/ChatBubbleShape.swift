//
//  ChatBubbleShape.swift
//  Blink
//
//  Created by Pavel Playerz0redd on 3.05.25.
//

import Foundation
import SwiftUI

struct ChatBubbleShape: Shape {
    let cornerRadius: CGFloat
    
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        path.move(to: CGPoint(x: rect.minX + cornerRadius, y: rect.minY))
        path.addLine(to: CGPoint(x: rect.maxX - cornerRadius, y: rect.minY))
        path.addArc(
            center: .init(x: rect.maxX - cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cornerRadius))
        
        path.addArc(
            center: .init(x: rect.maxX - cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(0),
            endAngle: .degrees(50),
            clockwise: false
        )
    
        
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX + 2, y: rect.maxY + 2),
            control: CGPoint(x: rect.maxX - 5, y: rect.maxY + 3)
        )
        
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX - cornerRadius, y: rect.maxY),
            control: CGPoint(x: rect.maxX - 5, y: rect.maxY + 10)
        )
        
        
        path.addLine(to: CGPoint(x: rect.minX + cornerRadius, y: rect.maxY))
        
        path.addArc(
            center: .init(x: rect.minX + cornerRadius, y: rect.maxY - cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )
        
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cornerRadius))
        
        path.addArc(
            center: .init(x: rect.minX + cornerRadius, y: rect.minY + cornerRadius),
            radius: cornerRadius,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )
        
        
//        
        
        
        path.closeSubpath()
        
        return path
    }
}
