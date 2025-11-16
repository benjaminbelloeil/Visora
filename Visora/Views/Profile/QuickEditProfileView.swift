//
//  QuickEditProfileView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI
import PhotosUI

struct QuickEditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var profile: UserProfile
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                .foregroundColor(.actionColor)
                
                Spacer()
                
                Text("Edit Profile")
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button("Done") {
                    // Provide haptic feedback on save
                    let generator = UINotificationFeedbackGenerator()
                    generator.notificationOccurred(.success)
                    
                    // Save profile image if a new one was selected
                    if let selectedImage = selectedImage {
                        profile.profileImage = selectedImage
                    }
                    
                    // Update the full name from first + last
                    profile.name = "\(profile.firstName) \(profile.lastName)".trimmingCharacters(in: .whitespaces)
                    viewModel.updateProfile(profile)
                    dismiss()
                }
                .foregroundColor(.actionColor)
                .fontWeight(.semibold)
                .accessibilityLabel("Save profile changes")
                .accessibilityHint("Saves your profile and closes this screen")
            }
            .padding()
            .background(Color(UIColor.systemBackground))
            
            ScrollView {
                VStack(spacing: 24) {
                    // Profile Image Section
                    VStack(spacing: 8) {
                        profileImagePicker
                        
                        Text("Change Profile Picture")
                            .font(.subheadline)
                            .foregroundColor(.actionColor)
                    }
                    .padding(.top, 20)
                    
                    // Quick Edit Fields - Just the essentials
                    VStack(spacing: 20) {
                        // First Name
                        FormField(
                            label: "First Name",
                            text: $profile.firstName,
                            hasCheckmark: !profile.firstName.isEmpty
                        )
                        
                        // Last Name
                        FormField(
                            label: "Last Name",
                            text: $profile.lastName,
                            hasCheckmark: !profile.lastName.isEmpty
                        )
                        
                        // Location Picker
                        LocationPicker(
                            selectedLocation: $profile.location,
                            hasCheckmark: !profile.location.isEmpty
                        )
                    }
                    .padding(.horizontal)
                    
                    // Link to full profile
                    Button {
                        dismiss()
                        // Navigate to full EditProfileView will happen from ProfileView
                    } label: {
                        HStack {
                            Text("Edit More Details")
                                .font(.subheadline)
                                .foregroundColor(.actionColor)
                            Image(systemName: "arrow.right")
                                .font(.caption)
                                .foregroundColor(.actionColor)
                        }
                        .padding()
                    }
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let newValue = newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    profile.profileImageName = UUID().uuidString
                }
            }
        }
    }
    
    private var profileImagePicker: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
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
                    if let selectedImage = selectedImage {
                        Image(uiImage: selectedImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .clipShape(Circle())
                    } else if let profileImage = profile.profileImage {
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
        }
    }
}

#Preview {
    QuickEditProfileView(profile: UserProfile.sampleProfile, viewModel: ProfileViewModel())
}
