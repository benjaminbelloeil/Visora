//
//  UserProfile.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import UIKit

struct UserProfile: Codable {
    var id: String
    var name: String
    var bio: String?
    var profileImageName: String?
    var joinDate: Date
    var preferences: UserPreferences
    
    // Non-codable property for actual image
    var profileImage: UIImage? {
        // In a real app, you'd load from profileImageName
        return nil
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, bio, profileImageName, joinDate, preferences
    }
    
    init(
        id: String = UUID().uuidString,
        name: String,
        bio: String? = nil,
        profileImageName: String? = nil,
        joinDate: Date = Date(),
        preferences: UserPreferences = UserPreferences()
    ) {
        self.id = id
        self.name = name
        self.bio = bio
        self.profileImageName = profileImageName
        self.joinDate = joinDate
        self.preferences = preferences
    }
}

struct UserPreferences: Codable {
    var enableNotifications: Bool = true
    var shareLocation: Bool = false
    var preferredLanguage: String = "en"
    var theme: String = "system"
    
    init(
        enableNotifications: Bool = true,
        shareLocation: Bool = false,
        preferredLanguage: String = "en",
        theme: String = "system"
    ) {
        self.enableNotifications = enableNotifications
        self.shareLocation = shareLocation
        self.preferredLanguage = preferredLanguage
        self.theme = theme
    }
}

extension UserProfile {
    static let sampleProfile = UserProfile(
        name: "Travel Explorer",
        bio: "Passionate about discovering new places and cultures around the world."
    )
}
