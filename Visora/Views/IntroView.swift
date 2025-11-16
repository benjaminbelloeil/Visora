//
//  IntroView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct IntroView: View {
    @State private var isAnimating = false
    @State private var showTitle = false
    @State private var opacity: Double = 0
    
    var body: some View {
        ZStack {
            // Elegant gradient background
            LinearGradient(
                colors: [
                    Color.appBackground,
                    Color.actionColor.opacity(0.15),
                    Color.appBackground
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()
            
            VStack(spacing: 0) {
                Spacer()
                
                // App Icon with elegant animations
                ZStack {
                    // Outer pulsing glow
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.actionColor.opacity(0.4),
                                    Color.actionColor.opacity(0.2),
                                    Color.actionColor.opacity(0.05),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 80,
                                endRadius: 200
                            )
                        )
                        .frame(width: 400, height: 400)
                        .scaleEffect(isAnimating ? 1.3 : 0.9)
                        .opacity(isAnimating ? 0.4 : 0.8)
                    
                    // Middle glow ring
                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.actionColor.opacity(0.3),
                                    Color.actionColor.opacity(0.1),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 100,
                                endRadius: 180
                            )
                        )
                        .frame(width: 360, height: 360)
                        .scaleEffect(isAnimating ? 1.2 : 0.8)
                        .opacity(isAnimating ? 0.5 : 1)
                    
                    // App Icon
                    Image("AppIcon")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 200, height: 200)
                        .cornerRadius(45)
                        .shadow(color: Color.actionColor.opacity(0.4), radius: 30, x: 0, y: 15)
                        .scaleEffect(isAnimating ? 1.05 : 0.95)
                }
                .opacity(opacity)
                
                Spacer()
                    .frame(height: 80)
                
                // App Name with animation
                if showTitle {
                    VStack(spacing: 12) {
                        Text("Visora")
                            .font(.system(size: 56, weight: .bold, design: .rounded))
                            .foregroundStyle(
                                LinearGradient(
                                    colors: [
                                        Color.actionColor,
                                        Color.actionColor.opacity(0.8)
                                    ],
                                    startPoint: .leading,
                                    endPoint: .trailing
                                )
                            )
                            .transition(.scale.combined(with: .opacity))
                        
                        Text("Discover the World's Stories")
                            .font(.system(size: 18, weight: .medium))
                            .foregroundColor(.subTextColor)
                            .transition(.opacity)
                    }
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Staggered animations for elegant entrance
            withAnimation(.easeOut(duration: 1.0)) {
                opacity = 1.0
            }
            
            // Start icon pulsing with smooth easing
            withAnimation(
                Animation
                    .easeInOut(duration: 2.5)
                    .repeatForever(autoreverses: true)
            ) {
                isAnimating = true
            }
            
            // Show title after delay with spring animation
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    showTitle = true
                }
            }
        }
    }
}

#Preview {
    IntroView()
}
