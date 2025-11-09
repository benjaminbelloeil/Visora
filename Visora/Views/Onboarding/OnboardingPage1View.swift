//
//  OnboardingPage1View.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage1View: View {
    var body: some View {
        ZStack {
            // Background gradient or image
            LinearGradient(
                colors: [.blue.opacity(0.6), .purple.opacity(0.6)],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Spacer()
                
                Image(systemName: "camera.fill")
                    .font(.system(size: 100))
                    .foregroundColor(.white)
                
                Text("Capture Your Journey")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text("Take photos of your travels and let AI identify landmarks and destinations")
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
    OnboardingPage1View()
}
