//
//  OnboardingContainerView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct OnboardingContainerView: View {
    @State private var currentPage = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    
    var body: some View {
        ZStack {
            TabView(selection: $currentPage) {
                OnboardingPage1View()
                    .tag(0)
                
                OnboardingPage2View()
                    .tag(1)
                
                OnboardingPage3View()
                    .tag(2)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
            .ignoresSafeArea()
            
            VStack {
                Spacer()
                
                PageIndicator(currentPage: currentPage, pageCount: 3)
                    .padding(.bottom, 20)
                
                if currentPage == 2 {
                    PrimaryButton(title: "Get Started") {
                        hasCompletedOnboarding = true
                    }
                    .padding(.horizontal, 40)
                    .padding(.bottom, 40)
                } else {
                    Button("Skip") {
                        hasCompletedOnboarding = true
                    }
                    .foregroundColor(.gray)
                    .padding(.bottom, 40)
                }
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
}
