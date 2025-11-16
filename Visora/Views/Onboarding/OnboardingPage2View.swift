//
//  OnboardingPage2View.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage2View: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                // Image at the top - extends to top edge
                Image("Onboarding2")
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity)
                    .frame(height: geometry.size.height * 0.54)
                    .clipShape(BottomRoundedRectangle(radius: 24))
                
                // Text content
                VStack(spacing: 24) {
                    VStack(spacing: 4) {
                        Text("Discover landmarks")
                            .font(.custom("Montserrat", size: 34).weight(.black))
                            .foregroundColor(.textColor)
                        
                        HStack(spacing: 8) {
                            Text("with")
                                .font(.custom("Montserrat", size: 34).weight(.black))
                                .foregroundColor(.textColor)
                            
                            ZStack(alignment: .bottom) {
                                Text("AI insights")
                                    .font(.custom("Montserrat", size: 34).weight(.black))
                                    .foregroundColor(Color.actionColor)
                                
                                CurvedUnderline()
                                    .fill(Color.actionColor)
                                    .frame(width: 162, height: 8)
                                    .offset(y: 24)
                            }
                        }
                    }
                    .padding(.top, 40)
                    
                    Text("Snap a photo and instantly learn the\nhistory, culture, and fascinating facts\nabout any landmark around the world")
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
    OnboardingPage2View()
}
