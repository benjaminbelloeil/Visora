//
//  VisoraApp.swift
//  Visora
//
//  Created by Benjamin Belloeil on 07/11/25.
//

import SwiftUI

@main
struct VisoraApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @AppStorage("hasSeenIntro") private var hasSeenIntro = false
    @StateObject private var appSettings = AppSettings.shared
    @StateObject private var homeViewModel = HomeViewModel.shared
    @State private var showLoadingAfterOnboarding = false
    @State private var isMainAppReady = false
    
    var body: some Scene {
        WindowGroup {
            Group {
                if !hasSeenIntro {
                    // Show intro screen first
                    IntroView()
                        .onAppear {
                            // Show intro for 2.5 seconds
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    hasSeenIntro = true
                                }
                            }
                        }
                } else if !hasCompletedOnboarding {
                    // Show onboarding after intro
                    OnboardingContainerView()
                        .preferredColorScheme(appSettings.colorScheme)
                } else if showLoadingAfterOnboarding {
                    // Show loading screen after onboarding
                    LoadingView()
                } else if isMainAppReady {
                    // Show main app once everything is loaded
                    ContentView()
                        .preferredColorScheme(appSettings.colorScheme)
                }
            }
            .animation(.easeInOut(duration: 0.8), value: hasSeenIntro)
            .animation(.easeInOut(duration: 0.8), value: hasCompletedOnboarding)
            .animation(.easeInOut(duration: 0.8), value: showLoadingAfterOnboarding)
            .animation(.easeInOut(duration: 0.8), value: isMainAppReady)
            .onChange(of: hasCompletedOnboarding) { oldValue, newValue in
                // When onboarding is completed, show loading screen immediately
                if newValue == true && oldValue == false {
                    showLoadingAfterOnboarding = true
                    
                    // Preload data while showing loading screen
                    Task {
                        // First, preload all data
                        await homeViewModel.preloadData()
                        
                        // Wait at least 2.5 seconds total for loading screen
                        try? await Task.sleep(nanoseconds: 2_500_000_000) // 2.5 seconds
                        
                        // Give extra time for UI to render before transition
                        try? await Task.sleep(nanoseconds: 200_000_000) // Extra 0.2s
                        
                        await MainActor.run {
                            showLoadingAfterOnboarding = false
                            // Wait one more frame before setting ready
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                withAnimation(.easeInOut(duration: 0.8)) {
                                    isMainAppReady = true
                                }
                            }
                        }
                    }
                }
            }
            .onAppear {
                // If user has already completed onboarding, preload data
                if hasCompletedOnboarding && hasSeenIntro {
                    Task {
                        await homeViewModel.preloadData()
                        await MainActor.run {
                            isMainAppReady = true
                        }
                    }
                }
            }
        }
    }
}
