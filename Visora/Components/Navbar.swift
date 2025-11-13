//
//  Navbar.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct Navbar: View {
    @State private var selectedTab = 0
    
    init() {
        // Customize tab bar appearance with transparent background
        let appearance = UITabBarAppearance()
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .clear
        
        // Unselected tab item color
        let normalItemAppearance = UITabBarItemAppearance()
        normalItemAppearance.normal.iconColor = UIColor(Color.subTextColor)
        normalItemAppearance.normal.titleTextAttributes = [
            .foregroundColor: UIColor(Color.subTextColor)
        ]
        
        // Selected tab item color
        normalItemAppearance.selected.iconColor = UIColor(Color.actionColor)
        normalItemAppearance.selected.titleTextAttributes = [
            .foregroundColor: UIColor(Color.actionColor)
        ]
        
        appearance.stackedLayoutAppearance = normalItemAppearance
        appearance.inlineLayoutAppearance = normalItemAppearance
        appearance.compactInlineLayoutAppearance = normalItemAppearance
        
        UITabBar.appearance().standardAppearance = appearance
        if #available(iOS 15.0, *) {
            UITabBar.appearance().scrollEdgeAppearance = appearance
        }
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Home", systemImage: "house", value: 0) {
                HomeView(selectedTab: $selectedTab)
            }
            
            Tab("Calendar", systemImage: "calendar", value: 1) {
                CalendarView()
            }
            
            Tab("Map", systemImage: "map", value: 3) {
                MapView()
            }
            
            Tab("Profile", systemImage: "person", value: 4) {
                ProfileView()
            }
            
            Tab(value: 2, role: .search) {
                PhotoCaptureView()
            } label: {
                Label("Capture", systemImage: "camera.viewfinder")
            }
        }
        .accentColor(.actionColor)
    }
}

#Preview {
    Navbar()
}
