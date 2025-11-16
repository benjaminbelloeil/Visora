//
//  ProfileView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct ProfileView: View {
    @StateObject private var viewModel = ProfileViewModel()
    @State private var showQuickEdit = false
    @State private var dragOffset: CGFloat = 0
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                // Header with Profile Title and Edit Button
                HStack {
                    Text("Profile")
                        .font(.title)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Button {
                        showQuickEdit = true
                    } label: {
                        Image(systemName: "pencil")
                            .foregroundColor(.actionColor)
                            .font(.title3)
                    }
                    .accessibilityLabel("Quick Edit")
                    .accessibilityHint("Opens quick edit for basic profile info")
                }
                .padding(.horizontal)
                .padding(.top, 8)
                .padding(.bottom, 16)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Profile Header
                        VStack(spacing: 12) {
                            // Profile Image
                            Circle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.orange, Color.blue],
                                        startPoint: .topLeading,
                                        endPoint: .bottomTrailing
                                    )
                                )
                                .frame(width: 100, height: 100)
                                .overlay {
                                    if let profileImage = viewModel.userProfile.profileImage {
                                        Image(uiImage: profileImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .clipShape(Circle())
                                    } else {
                                        Image(systemName: "person.fill")
                                            .font(.system(size: 50))
                                            .foregroundColor(.white)
                                    }
                                }
                                .accessibilityLabel("Profile Picture")
                                .accessibilityHint(viewModel.userProfile.profileImage != nil ? "Your profile photo" : "Default profile icon")
                            
                            // Name
                            Text(viewModel.userProfile.name)
                                .font(.title2)
                                .fontWeight(.bold)
                            
                            // Email
                            Text(viewModel.userProfile.email)
                                .font(.subheadline)
                                .foregroundColor(.subTextColor)
                        }
                        .padding(.top, 8)
                        
                        // Stats Section
                        HStack(spacing: 40) {
                            StatView(
                                title: "Monuments",
                                value: "\(viewModel.userProfile.monumentsCount)"
                            )
                            
                            StatView(
                                title: "Countries",
                                value: "\(viewModel.userProfile.countriesCount)"
                            )
                            
                            StatView(
                                title: "Favorites",
                                value: "\(viewModel.userProfile.favoritesCount)"
                            )
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 20)
                        .padding(.horizontal)
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                        
                        // Menu Items
                        VStack(spacing: 0) {
                            ProfileMenuItem(
                                icon: "person",
                                title: "Profile",
                                destination: AnyView(EditProfileView(profile: viewModel.userProfile, viewModel: viewModel))
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            ProfileMenuItem(
                                icon: "bookmark",
                                title: "Bookmarked",
                                destination: AnyView(BookmarkedView())
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            ProfileMenuItem(
                                icon: "photo.stack",
                                title: "Previous Analysis",
                                destination: AnyView(PreviousAnalysisView())
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            ProfileMenuItem(
                                icon: "gearshape",
                                title: "Settings",
                                destination: AnyView(SettingsView(viewModel: viewModel))
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            ProfileMenuItem(
                                icon: "questionmark.circle",
                                title: "Help & Support",
                                destination: AnyView(HelpSupportView())
                            )
                            
                            Divider()
                                .padding(.leading, 60)
                            
                            ProfileMenuItem(
                                icon: "info.circle",
                                title: "About Visora",
                                destination: AnyView(AboutVisoraView())
                            )
                        }
                        .background(Color(UIColor.secondarySystemBackground))
                        .cornerRadius(12)
                        .padding(.horizontal)
                    }
                    .padding(.bottom, 20)
                }
            }
            .background(Color(UIColor.systemBackground))
            .offset(x: dragOffset)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        // Only allow dragging to the right
                        if value.translation.width > 0 {
                            dragOffset = value.translation.width
                        }
                    }
                    .onEnded { value in
                        if value.translation.width > 100 {
                            // Swipe threshold met - provide haptic feedback
                            let impactMed = UIImpactFeedbackGenerator(style: .medium)
                            impactMed.impactOccurred()
                            
                            // Since this is in a tab, we'll just reset
                            withAnimation {
                                dragOffset = 0
                            }
                        } else {
                            withAnimation {
                                dragOffset = 0
                            }
                        }
                    }
            )
        }
        .sheet(isPresented: $showQuickEdit) {
            QuickEditProfileView(profile: viewModel.userProfile, viewModel: viewModel)
        }
        .onAppear {
            viewModel.calculateStats()
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
                .foregroundColor(.actionColor)
            Text(title)
                .font(.caption)
                .foregroundColor(.subTextColor)
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("\(value) \(title)")
    }
}

struct ProfileMenuItem: View {
    let icon: String
    let title: String
    let destination: AnyView
    
    var body: some View {
        NavigationLink {
            destination
        } label: {
            HStack(spacing: 16) {
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.subTextColor)
                    .frame(width: 24)
                
                Text(title)
                    .font(.body)
                    .foregroundColor(.textColor)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .font(.caption)
                    .foregroundColor(.subTextColor)
            }
            .padding(.horizontal)
            .padding(.vertical, 16)
            .background(Color(UIColor.secondarySystemBackground))
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel(title)
        .accessibilityHint("Tap to open \(title)")
    }
}

#Preview {
    ProfileView()
}
