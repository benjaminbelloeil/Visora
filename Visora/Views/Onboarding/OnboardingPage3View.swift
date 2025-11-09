//
//  OnboardingPage3View.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage3View: View {
    var body: some View {
        ZStack {
            // Background gradient or image
            LinearGradient(
                colors: [.orange.opacity(0.6), .pink.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "map.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                
                Text("Discover New Places")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Explore nearby destinations and plan your next adventure with confidence")
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
    OnboardingPage3View()
}
