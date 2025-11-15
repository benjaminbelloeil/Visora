//
//  ProfileView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        NavigationStack {
            List {
                // Profile header
                Section {
                    HStack(spacing: 16) {
                        // Profile image
                        Circle()
                            .fill(Color.actionColor.opacity(0.3))
                            .frame(width: 80, height: 80)
                            .overlay {
                                if let profileImage = viewModel.userProfile.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .clipShape(Circle())
                                } else {
                                    Image(systemName: "person.fill")
                                        .font(.system(size: 40))
                                        .foregroundColor(.actionColor)
                                }
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.userProfile.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if let bio = viewModel.userProfile.bio {
                                Text(bio)
                                    .font(.subheadline)
                                    .foregroundColor(.subTextColor)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Stats
                Section {
                    Text("Member since \(viewModel.userProfile.joinDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.subTextColor)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                }
                
                // Settings
                Section {
                    NavigationLink(destination: EditProfileView(profile: viewModel.userProfile)) {
                        Label("Edit Profile", systemImage: "pencil")
                            .foregroundColor(.textColor)
                    }
                    
                    NavigationLink(destination: Text("Settings")) {
                        Label("Settings", systemImage: "gear")
                            .foregroundColor(.textColor)
                    }
                    
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock.shield")
                            .foregroundColor(.textColor)
                    }
                }
                
                // About
                Section {
                    NavigationLink(destination: Text("About")) {
                        Label("About Visora", systemImage: "info.circle")
                            .foregroundColor(.textColor)
                    }
                    
                    NavigationLink(destination: Text("Help")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                            .foregroundColor(.textColor)
                    }
                }
            }
            .navigationTitle("Profile")
            .tint(.actionColor)
        }
    }
}

struct StatView: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 4) {
            Text(value)
                .font(.title2)
                .fontWeight(.bold)
            Text(title)
                .font(.caption)
                .foregroundColor(.subTextColor)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
