//
//  UserProfileHeader.swift
//  Visora
//
//  Created on November 11, 2025.
//

import SwiftUI

struct UserProfileHeader: View {
    let userName: String
    let hasNotification: Bool
    let onNotificationTap: () -> Void
    
    var body: some View {
        ZStack {
            Group {
                // Background pill for name
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 118, height: 44)
                    .background(Color.cardBackground)
                    .cornerRadius(22)
                    .offset(x: -108.50, y: 0)
                
                // Profile picture - orange circle with person icon
                Circle()
                    .fill(
                        LinearGradient(
                            colors: [Color(red: 1.0, green: 0.45, blue: 0.2).opacity(0.8), Color(red: 1.0, green: 0.45, blue: 0.2)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .frame(width: 37, height: 37)
                    .overlay(
                        Image(systemName: "person.fill")
                            .foregroundColor(.white)
                            .font(.system(size: 18))
                    )
                    .offset(x: -145, y: 0.50)
            }
            
            Group {
                // User name text
                Text(userName)
                    .font(Font.custom("SF Pro", size: 14))
                    .lineSpacing(16)
                    .foregroundColor(Color(red: 0.11, green: 0.12, blue: 0.16))
                    .offset(x: -89, y: 0)
                
                // Notification bell background
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.cardBackground)
                    )
                    .offset(x: 180.50, y: 0)
                
                // Bell icon
                Button(action: onNotificationTap) {
                    ZStack {
                        Image(systemName: "bell")
                            .font(.system(size: 20))
                            .foregroundColor(Color(red: 0.11, green: 0.12, blue: 0.16))
                        
                        if hasNotification {
                            Circle()
                                .fill(Color(red: 1.0, green: 0.45, blue: 0.2))
                                .frame(width: 8, height: 8)
                                .offset(x: 10, y: -8)
                        }
                    }
                    .frame(width: 44, height: 44)
                }
                .offset(x: 180.50, y: 0)
            }
        }
        .frame(width: 335, height: 44)
    }
}

#Preview {
    VStack {
        UserProfileHeader(userName: "Benjamin", hasNotification: true) {
            print("Notification tapped")
        }
        .padding()
        
        UserProfileHeader(userName: "John Doe", hasNotification: false) {
            print("Notification tapped")
        }
        .padding()
    }
}
