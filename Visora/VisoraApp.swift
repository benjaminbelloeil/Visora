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
    
    var body: some Scene {
        WindowGroup {
            if hasCompletedOnboarding {
                ContentView()
            } else {
                OnboardingContainerView()
            }
        }
    }
}
