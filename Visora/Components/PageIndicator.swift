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
                Circle()
                    .fill(currentPage == index ? Color.accentColor : Color.gray.opacity(0.5))
                    .frame(width: currentPage == index ? 10 : 8, height: currentPage == index ? 10 : 8)
                    .animation(.easeInOut, value: currentPage)
            }
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        PageIndicator(currentPage: 0, pageCount: 3)
        PageIndicator(currentPage: 1, pageCount: 3)
        PageIndicator(currentPage: 2, pageCount: 3)
    }
}
