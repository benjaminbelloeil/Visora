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
    
    private let userDefaultsKey = "UserProfile"
    
    init() {
        loadProfile()
        calculateStats()
    }
    
    func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        }
    }
    
    func saveProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: userDefaultsKey)
        }
    }
    
    func updateProfile(_ profile: UserProfile) {
        userProfile = profile
        saveProfile()
    }
    
    func updatePreferences(_ preferences: UserPreferences) {
        userProfile.preferences = preferences
        saveProfile()
    }
    
    func calculateStats() {
        // Get saved photos from CalendarViewModel
        let calendarVM = CalendarViewModel.shared
        let allPhotos = calendarVM.photosByDate.values.flatMap { $0 }
        
        // Monuments = total unique photos (count all photos, no duplicates by ID)
        let uniquePhotoIds = Set(allPhotos.map { $0.id })
        userProfile.monumentsCount = uniquePhotoIds.count
        
        // Countries = unique countries from location field (e.g., "Florence, Italy" → "Italy")
        let countries = Set(allPhotos.compactMap { photo -> String? in
            guard let location = photo.location else { return nil }
            // Extract country (last part after comma)
            let components = location.split(separator: ",").map { $0.trimmingCharacters(in: .whitespaces) }
            return components.last
        })
        userProfile.countriesCount = countries.count
        
        // Favorites = only photos marked as favorite
        let favorites = allPhotos.filter { $0.isFavorite }
        userProfile.favoritesCount = favorites.count
        
        saveProfile()
    }
    
    func signOut() {
        // Clear user data
        UserDefaults.standard.removeObject(forKey: userDefaultsKey)
        userProfile = UserProfile.sampleProfile
    }
}
