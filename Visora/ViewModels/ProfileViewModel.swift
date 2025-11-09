//
//  ProfileViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import Combine

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var userProfile: UserProfile = UserProfile.sampleProfile
    
    func updateProfile(name: String, bio: String?) {
        userProfile.name = name
        userProfile.bio = bio
        // TODO: Save to persistent storage
    }
    
    func updatePreferences(_ preferences: UserPreferences) {
        userProfile.preferences = preferences
        // TODO: Save to persistent storage
    }
    
    func signOut() {
        // TODO: Implement sign out functionality
        print("Signing out...")
    }
}
