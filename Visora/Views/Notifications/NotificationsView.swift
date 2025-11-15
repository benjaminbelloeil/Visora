//
//  NotificationsView.swift
//  Visora
//
//  Created on November 11, 2025.
//

import SwiftUI

struct NotificationsView: View {
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    // Sample notifications
                    NotificationCard(
                        icon: "heart.fill",
                        iconColor: .red,
                        title: "New Like",
                        message: "John liked your photo from Bali",
                        time: "2h ago"
                    )
                    
                    NotificationCard(
                        icon: "person.fill.badge.plus",
                        iconColor: .blue,
                        title: "New Follower",
                        message: "Sarah started following you",
                        time: "5h ago"
                    )
                    
                    NotificationCard(
                        icon: "mappin.circle.fill",
                        iconColor: Color(red: 1.0, green: 0.45, blue: 0.2),
                        title: "New Destination",
                        message: "Discover amazing places in Thailand",
                        time: "1d ago"
                    )
                    
                    NotificationCard(
                        icon: "star.fill",
                        iconColor: .yellow,
                        title: "Achievement Unlocked",
                        message: "You've visited 10 destinations!",
                        time: "2d ago"
                    )
                }
                .padding()
            }
            .navigationTitle("Notifications")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray.opacity(0.6))
                            .font(.system(size: 24))
                    }
                }
            }
        }
    }
}

struct NotificationCard: View {
    let icon: String
    let iconColor: Color
    let title: String
    let message: String
    let time: String
    
    var body: some View {
        HStack(spacing: 12) {
            // Icon
            Circle()
                .fill(iconColor.opacity(0.15))
                .frame(width: 50, height: 50)
                .overlay(
                    Image(systemName: icon)
                        .foregroundColor(iconColor)
                        .font(.system(size: 22))
                )
            
            // Content
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.custom("Montserrat", size: 16))
                    .fontWeight(.bold)
                    .foregroundColor(.textColor)
                
                Text(message)
                    .font(.custom("Nunito Sans", size: 14))
                    .foregroundColor(.subTextColor)
                    .lineLimit(2)
                
                Text(time)
                    .font(.custom("Nunito Sans", size: 12))
                    .foregroundColor(.subTextColor.opacity(0.7))
            }
            
            Spacer()
        }
        .padding()
        .background(Color.cardSurface)
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
    }
}

#Preview {
    NotificationsView()
}
