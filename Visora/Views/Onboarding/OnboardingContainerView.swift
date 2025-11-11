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
                HStack {
                    Spacer()
                    
                    if currentPage < 2 {
                        Button {
                            hasCompletedOnboarding = true
                        } label: {
                            Text("Skip")
                                .font(.custom("Inter", size: 18).weight(.medium))
                                .foregroundColor(.white)
                        }
                        .padding(.trailing, 30)
                        .padding(.top, 20)
                    }
                }
                
                Spacer()
                
                // Page indicator
                PageIndicator(currentPage: currentPage, pageCount: 3)
                    .padding(.bottom, 24)
                
                // Button
                if currentPage == 0 {
                    Button {
                        withAnimation {
                            currentPage = 1
                        }
                    } label: {
                        Text("Get Started")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.primaryColor)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                    
                } else if currentPage < 2 {
                    Button {
                        withAnimation {
                            currentPage += 1
                        }
                    } label: {
                        Text("Next")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.primaryColor)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)
                    
                } else {
                    Button {
                        hasCompletedOnboarding = true
                    } label: {
                        Text("Next")
                            .font(.custom("Inter", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .frame(height: 56)
                            .background(Color.primaryColor)
                            .cornerRadius(16)
                    }
                    .padding(.horizontal, 40)

                }
            }
        }
    }
}

#Preview {
    OnboardingContainerView()
}
