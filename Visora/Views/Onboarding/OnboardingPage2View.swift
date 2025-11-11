//
//  OnboardingPage2View.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingPage2View: View {
    var body: some View {
        VStack(spacing: 0) {
            // Image at the top - extends to top edge
            Image("Onboarding2")
                .resizable()
                .scaledToFill()
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.54)
                .clipShape(BottomRoundedRectangle(radius: 24))
            
            // Text content
            VStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("It's a big world out")
                        .font(.custom("Montserrat", size: 38).weight(.black))
                        .foregroundColor(.textColor)
                    
                    HStack(spacing: 8) {
                        Text("there go")
                            .font(.custom("Montserrat", size: 38).weight(.black))
                            .foregroundColor(.textColor)
                        
                        ZStack(alignment: .bottom) {
                            Text("explore")
                                .font(.custom("Montserrat", size: 38).weight(.black))
                                .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                            
                            CurvedUnderline()
                                .fill(Color(red: 1.0, green: 0.45, blue: 0.2))
                                .frame(width: 125, height: 9)
                                .offset(y: 22)
                        }
                    }
                }
                .padding(.top, 40)
                
                Text("To get the best of your adventure you\njust need to leave and go where you like.\nwe are waiting for you")
                    .font(.custom("Nunito Sans", size: 17))
                    .foregroundColor(.subTextColor)
                    .multilineTextAlignment(.center)
                    .padding(.top, 16)
            }
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .background(Color.white)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    OnboardingPage2View()
}
