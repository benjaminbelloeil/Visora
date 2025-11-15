//
//  Color+Theme.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

extension Color {
    static let actionColor = Color("ActionColor")
    static let primaryColor = Color("PrimaryColor")
    static let textColor = Color("TextColor")
    static let subTextColor = Color("SubTextColor")
    
    // Adaptive colors for light/dark mode
    static let cardBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.15, green: 0.15, blue: 0.17, alpha: 1.0) // Dark gray for dark mode
            : UIColor(red: 0.96, green: 0.96, blue: 0.97, alpha: 1.0) // Light gray for light mode
    })
    
    static let appBackground = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 1.0) // Black for dark mode
            : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // White for light mode
    })
    
    static let cardSurface = Color(UIColor { traitCollection in
        traitCollection.userInterfaceStyle == .dark
            ? UIColor(red: 0.11, green: 0.11, blue: 0.12, alpha: 1.0) // Darker surface for dark mode
            : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) // White for light mode
    })
}

