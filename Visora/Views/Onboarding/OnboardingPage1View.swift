//
//  OnboardingPage1View.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage1View: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Image at the top - extends to top edge
                Image("Onboarding1")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.54)
                    .clipShape(BottomRoundedRectangle(radius: 24))
            
            // Text content
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("Capture the world")
                        .font(.custom("Montserrat", size: 34).weight(.black))
                        .foregroundColor(.textColor)
                    
                    HStack(spacing: 8) {
                        Text("through your")
                            .font(.custom("Montserrat", size: 34).weight(.black))
                            .foregroundColor(.textColor)
                        
                        ZStack(alignment: .bottom) {
                            Text("camera")
                                .font(.custom("Montserrat", size: 34).weight(.black))
                                .foregroundColor(Color.actionColor)
                            
                            CurvedUnderline()
                                .fill(Color.actionColor)
                                .frame(width: 130, height: 8)
                                .offset(y: 19)
                        }
                    }
                }
                .padding(.top, 40)
                
                Text("Transform your travel photos into\nintelligent memories with AI-powered\nlandmark recognition and insights")
                    .font(.custom("Nunito Sans", size: 17))
                    .foregroundColor(.subTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 30)
            
            Spacer()
            }
            .background(Color.appBackground)
            .ignoresSafeArea(edges: .top)
        }
    }
}

#Preview {
    OnboardingPage1View()
}
