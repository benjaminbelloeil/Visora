//
//  CustomTabBar.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct CustomTabBar: View {
    @Binding var selectedTab: Int
    
    var body: some View {
        HStack(spacing: 0) {
            TabBarButton(
                icon: "house.fill",
                title: "Home",
                isSelected: selectedTab == 0
            ) {
                selectedTab = 0
            }
            
            TabBarButton(
                icon: "calendar",
                title: "Calendar",
                isSelected: selectedTab == 1
            ) {
                selectedTab = 1
            }
            
            TabBarButton(
                icon: "camera.fill",
                title: "Capture",
                isSelected: selectedTab == 2,
                isCenter: true
            ) {
                selectedTab = 2
            }
            
            TabBarButton(
                icon: "map.fill",
                title: "Map",
                isSelected: selectedTab == 3
            ) {
                selectedTab = 3
            }
            
            TabBarButton(
                icon: "person.fill",
                title: "Profile",
                isSelected: selectedTab == 4
            ) {
                selectedTab = 4
            }
        }
        .padding(.horizontal)
        .padding(.top, 8)
        .padding(.bottom, 20)
        .background(
            Color(.systemBackground)
                .shadow(color: .black.opacity(0.1), radius: 10, y: -5)
        )
    }
}

struct TabBarButton: View {
    let icon: String
    let title: String
    let isSelected: Bool
    var isCenter: Bool = false
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 4) {
                Image(systemName: icon)
                    .font(.system(size: isCenter ? 28 : 24))
                    .foregroundColor(isSelected ? .accentColor : .gray)
                
                if !isCenter {
                    Text(title)
                        .font(.caption2)
                        .foregroundColor(isSelected ? .accentColor : .gray)
                }
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
        }
    }
}

#Preview {
    CustomTabBar(selectedTab: .constant(0))
}
