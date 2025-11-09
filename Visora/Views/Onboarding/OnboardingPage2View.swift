//
//  OnboardingPage2View.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage2View: View {
    var body: some View {
        ZStack {
            // Background gradient or image
            LinearGradient(
                colors: [.green.opacity(0.6), .teal.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "calendar")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                
                Text("Track Your Memories")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("View your travel timeline and revisit special moments from every adventure")
                    .font(.title3)
                    .foregroundColor(.white.opacity(0.9))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 40)
                
                Spacer()
            }
        }
    }
}

#Preview {
    OnboardingPage2View()
}
