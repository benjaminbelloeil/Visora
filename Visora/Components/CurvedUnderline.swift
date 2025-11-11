//
//  CurvedUnderline.swift
//  Visora
//
//  Created on November 10, 2025.
//

import SwiftUI

struct CurvedUnderline: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        
        let width = rect.width
        let height = rect.height
        
        // Start point (left side, lower and sharper)
        path.move(to: CGPoint(x: 0, y: height * 0.5))
        
        // Create a smile curve with sharper/lower sides
        // Control points higher up to create a more pronounced curve
        path.addCurve(
            to: CGPoint(x: width, y: height * 0.5),
            control1: CGPoint(x: width * 0.3, y: -20),
            control2: CGPoint(x: width * 0.7, y: -20)
        )
        
        // Close the path with less filling (thinner bottom)
        path.addCurve(
            to: CGPoint(x: 0, y: height * 0.5),
            control1: CGPoint(x: width * 0.7, y: height * -1.5),
            control2: CGPoint(x: width * 0.3, y: height * -1.5)
        )
        
        path.closeSubpath()
        
        return path
    }
}

#Preview {
    VStack(spacing: 30) {
        CurvedUnderline()
            .stroke(Color.orange, lineWidth: 2.5)
            .frame(width: 110, height: 8)
        
        CurvedUnderline()
            .stroke(Color.orange, lineWidth: 2.5)
            .frame(width: 130, height: 8)
        
        CurvedUnderline()
            .stroke(Color.orange, lineWidth: 2.5)
            .frame(width: 120, height: 8)
    }
    .padding()
}
