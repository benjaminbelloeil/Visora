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
        HStack(spacing: 0) {
            // Profile picture and name pill
            Button(action: onProfileTap) {
                HStack(spacing: 8) {
                    // Profile picture circle
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
                    
                    // User name text
                    Text(userName)
                        .font(.system(size: 15, weight: .medium))
                        .foregroundColor(.textColor)
                        .lineLimit(1)
                        .padding(.trailing, 12)
                }
                .padding(.leading, 4)
                .padding(.vertical, 4)
                .background(Color.cardBackground)
                .cornerRadius(25)
                .offset(x: -4)
            }
            .buttonStyle(.plain)
            
            Spacer()
            
            // Notification bell
            Button(action: onNotificationTap) {
                ZStack {
                    Circle()
                        .fill(Color.cardBackground)
                        .frame(width: 44, height: 44)
                    
                    Image(systemName: "bell")
                        .font(.system(size: 20))
                        .foregroundColor(.textColor)
                    
                    if hasNotification {
                        Circle()
                            .fill(Color(red: 1.0, green: 0.45, blue: 0.2))
                            .frame(width: 8, height: 8)
                            .offset(x: 9, y: -10)
                    }
                }
            }
        }
        .frame(height: 50)
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
