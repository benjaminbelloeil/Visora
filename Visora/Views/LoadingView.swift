//
//  LoadingView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Gradient background
            LinearGradient(
                colors: [
                    Color.appBackground,
                    Color.actionColor.opacity(0.1),
                    Color.appBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 40) {
                Spacer()
                
                // App Icon with animation
                ZStack {
                    // Outer glow circle
                    
                    // App Icon
                    Image("AppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 400, height: 400)
                        .cornerRadius(45) // iOS app icon corner radius scaled up
                        .padding(.top, 100)
                }
                
                // App Name
                Text("Visora")
                    .font(.system(size: 48, weight: .bold, design: .rounded))
                    .foregroundStyle(
                        LinearGradient(
                            colors: [Color.actionColor, Color.actionColor.opacity(0.7)],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
                    .opacity(opacity)
                
                Spacer()
            
                // Loading indicator
                VStack(spacing: 16) {
                    // Custom animated dots
                    HStack(spacing: 12) {
                        ForEach(0..<3) { index in
                            Circle()
                                .fill(Color.actionColor)
                                .frame(width: 12, height: 12)
                                .scaleEffect(isAnimating ? 1.0 : 0.5)
                                .animation(
                                    Animation
                                        .easeInOut(duration: 0.6)
                                        .repeatForever()
                                        .delay(Double(index) * 0.2),
                                    value: isAnimating
                                )
                        }
                    }
                    
                    Text("Loading your experience...")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.subTextColor)
                        .opacity(opacity)
                }
                .padding(.bottom, 50)
            }
        }
        .onAppear {
            // Fade in animation
            withAnimation(.easeIn(duration: 0.5)) {
                opacity = 1.0
            }
            
            // Start pulsing animation
            withAnimation(
                Animation
                    .easeInOut(duration: 1.5)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
        }
    }
}

#Preview {
    LoadingView()
}
