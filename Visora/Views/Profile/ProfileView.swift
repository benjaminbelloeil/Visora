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
                            .fill(Color.accentColor.opacity(0.3))
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
                                        .foregroundColor(.accentColor)
                                }
                            }
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text(viewModel.userProfile.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            if let bio = viewModel.userProfile.bio {
                                Text(bio)
                                    .font(.subheadline)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                    .padding(.vertical, 8)
                }
                
                // Stats
                Section {
                    Text("Member since \(viewModel.userProfile.joinDate.formatted(date: .abbreviated, time: .omitted))")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding(.vertical, 8)
                }
                
                // Settings
                Section {
                    NavigationLink(destination: EditProfileView(profile: viewModel.userProfile)) {
                        Label("Edit Profile", systemImage: "pencil")
                    }
                    
                    NavigationLink(destination: Text("Settings")) {
                        Label("Settings", systemImage: "gear")
                    }
                    
                    NavigationLink(destination: Text("Privacy")) {
                        Label("Privacy", systemImage: "lock.shield")
                    }
                }
                
                // About
                Section {
                    NavigationLink(destination: Text("About")) {
                        Label("About Visora", systemImage: "info.circle")
                    }
                    
                    NavigationLink(destination: Text("Help")) {
                        Label("Help & Support", systemImage: "questionmark.circle")
                    }
                }
            }
            .navigationTitle("Profile")
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
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    ProfileView()
}
