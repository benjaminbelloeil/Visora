//
//  PageIndicator.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct PageIndicator: View {
    let currentPage: Int
    let pageCount: Int
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(0..<pageCount, id: \.self) { index in
                if currentPage == index {
                    // Active indicator - elongated capsule
                    Capsule()
                        .fill(Color.primaryColor)
                        .frame(width: 30, height: 8)
                        .transition(.scale)
                } else {
                    // Inactive indicator - small circle
                    Circle()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                }
            }
        }
        .animation(.spring(response: 0.3, dampingFraction: 0.7), value: currentPage)
    }
}

#Preview {
    VStack(spacing: 20) {
        PageIndicator(currentPage: 0, pageCount: 3)
        PageIndicator(currentPage: 1, pageCount: 3)
        PageIndicator(currentPage: 2, pageCount: 3)
    }
}
