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
    var firstName: String
    var lastName: String
    var email: String
    var location: String
    var mobileNumber: String
    var countryCode: String
    var bio: String?
    var profileImageName: String?
    var joinDate: Date
    var preferences: UserPreferences
    
    // Stats
    var monumentsCount: Int = 0
    var countriesCount: Int = 0
    var favoritesCount: Int = 0
    
    // Non-codable property for actual image
    var profileImage: UIImage? {
        get {
            guard let imageName = profileImageName else { return nil }
            let fileManager = FileManager.default
            guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                return nil
            }
            let imageURL = documentsPath.appendingPathComponent(imageName)
            guard let imageData = try? Data(contentsOf: imageURL) else { return nil }
            return UIImage(data: imageData)
        }
        set {
            if let image = newValue {
                let imageName = profileImageName ?? UUID().uuidString
                self.profileImageName = imageName
                
                // Save image to documents directory
                let fileManager = FileManager.default
                guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                    return
                }
                let imageURL = documentsPath.appendingPathComponent(imageName)
                if let imageData = image.jpegData(compressionQuality: 0.8) {
                    try? imageData.write(to: imageURL)
                }
            } else {
                // Delete image if setting to nil
                if let imageName = profileImageName {
                    let fileManager = FileManager.default
                    guard let documentsPath = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
                        return
                    }
                    let imageURL = documentsPath.appendingPathComponent(imageName)
                    try? fileManager.removeItem(at: imageURL)
                }
                profileImageName = nil
            }
        }
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, firstName, lastName, email, location, mobileNumber, countryCode
        case bio, profileImageName, joinDate, preferences
        case monumentsCount, countriesCount, favoritesCount
    }
    
    init(
        id: String = UUID().uuidString,
        name: String,
        firstName: String = "",
        lastName: String = "",
        email: String = "",
        location: String = "",
        mobileNumber: String = "",
        countryCode: String = "+88",
        bio: String? = nil,
        profileImageName: String? = nil,
        joinDate: Date = Date(),
        preferences: UserPreferences = UserPreferences(),
        monumentsCount: Int = 0,
        countriesCount: Int = 0,
        favoritesCount: Int = 0
    ) {
        self.id = id
        self.name = name
        self.firstName = firstName
        self.lastName = lastName
        self.email = email
        self.location = location
        self.mobileNumber = mobileNumber
        self.countryCode = countryCode
        self.bio = bio
        self.profileImageName = profileImageName
        self.joinDate = joinDate
        self.preferences = preferences
        self.monumentsCount = monumentsCount
        self.countriesCount = countriesCount
        self.favoritesCount = favoritesCount
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
        name: "Leonardo",
        firstName: "Leonardo",
        lastName: "Ahmed",
        email: "leonardo@gmail.com",
        location: "Sylhet Bangladesh",
        mobileNumber: "01758-000666",
        countryCode: "+88",
        bio: "Passionate about discovering new places and cultures around the world.",
        monumentsCount: 360,
        countriesCount: 238,
        favoritesCount: 473
    )
}
