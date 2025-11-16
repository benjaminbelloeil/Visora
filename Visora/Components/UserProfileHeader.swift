//
//  UserProfileHeader.swift
//  Visora
//
//  Created on November 11, 2025.
//

import SwiftUI

struct UserProfileHeader: View {
    let userName: String
    let profileImage: UIImage?
    let hasNotification: Bool
    let onNotificationTap: () -> Void
    let onProfileTap: () -> Void
    
    var body: some View {
        ZStack {
            Group {
                // Background pill for name - tappable
                Button(action: onProfileTap) {
                    Rectangle()
                        .foregroundColor(.clear)
                        .frame(width: 130, height: 50)
                        .background(Color.cardBackground)
                        .cornerRadius(25)
                }
                .buttonStyle(.plain)
                .offset(x: -115, y: 0)
                
                // Profile picture - circle - also tappable
                Button(action: onProfileTap) {
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.45, blue: 0.2).opacity(0.8), Color(red: 1.0, green: 0.45, blue: 0.2)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 42, height: 42)
                        .overlay {
                            if let profileImage = profileImage {
                                Image(uiImage: profileImage)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            } else {
                                Image(systemName: "person.fill")
                                    .foregroundColor(.white)
                                    .font(.system(size: 20))
                            }
                        }
                }
                .buttonStyle(.plain)
                .offset(x: -150, y: 0)
            }
            
            Group {
                // User name text - tappable
                Button(action: onProfileTap) {
                    Text(userName)
                        .font(Font.custom("SF Pro", size: 15))
                        .fontWeight(.medium)
                        .lineSpacing(16)
                        .foregroundColor(.textColor)
                }
                .buttonStyle(.plain)
                .offset(x: -95, y: 0)
                
                // Notification bell background
                Circle()
                    .foregroundColor(.clear)
                    .frame(width: 50, height: 50)
                    .background(
                        Circle()
                            .fill(Color.cardBackground)
                    )
                    .offset(x: 175, y: 0)
                
                // Bell icon
                Button(action: onNotificationTap) {
                    ZStack {
                        Image(systemName: "bell.fill")
                            .font(.system(size: 22))
                            .foregroundColor(.textColor)
                        
                        if hasNotification {
                            Circle()
                                .fill(Color(red: 1.0, green: 0.45, blue: 0.2))
                                .frame(width: 9, height: 9)
                                .offset(x: 11, y: -9)
                        }
                    }
                    .frame(width: 50, height: 50)
                }
                .offset(x: 175, y: 0)
            }
        }
        .frame(width: 345, height: 50)
    }
}

#Preview {
    VStack {
        UserProfileHeader(userName: "Benjamin", profileImage: nil, hasNotification: true, onNotificationTap: {
            print("Notification tapped")
        }, onProfileTap: {
            print("Profile tapped")
        })
        .padding()
        
        UserProfileHeader(userName: "John Doe", profileImage: nil, hasNotification: false, onNotificationTap: {
            print("Notification tapped")
        }, onProfileTap: {
            print("Profile tapped")
        })
        .padding()
    }
}
