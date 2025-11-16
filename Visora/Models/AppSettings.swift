//
//  AppSettings.swift
//  Visora
//
//  Created on November 16, 2025.
//

import Foundation
import SwiftUI
import Combine

@MainActor
class AppSettings: ObservableObject {
    static let shared = AppSettings()
    
    @Published var locationServicesEnabled: Bool = false
    @Published var notificationsEnabled: Bool = false
    @Published var colorScheme: ColorScheme? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    private init() {
        // Load from UserDefaults
        self.locationServicesEnabled = UserDefaults.standard.bool(forKey: "locationServicesEnabled")
        self.notificationsEnabled = UserDefaults.standard.bool(forKey: "notificationsEnabled")
        
        let schemeString = UserDefaults.standard.string(forKey: "colorScheme") ?? "system"
        self.colorScheme = schemeString == "dark" ? .dark : (schemeString == "light" ? .light : nil)
        
        // Observe changes and save to UserDefaults
        $locationServicesEnabled
            .dropFirst() // Skip initial value
            .sink { value in
                UserDefaults.standard.set(value, forKey: "locationServicesEnabled")
            }
            .store(in: &cancellables)
        
        $notificationsEnabled
            .dropFirst()
            .sink { value in
                UserDefaults.standard.set(value, forKey: "notificationsEnabled")
            }
            .store(in: &cancellables)
        
        $colorScheme
            .dropFirst()
            .sink { value in
                let stringValue = value == .dark ? "dark" : (value == .light ? "light" : "system")
                UserDefaults.standard.set(stringValue, forKey: "colorScheme")
            }
            .store(in: &cancellables)
    }
}
