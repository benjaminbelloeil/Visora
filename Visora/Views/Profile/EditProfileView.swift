//
//  EditProfileView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import PhotosUI

struct EditProfileView: View {
    @Environment(\.dismiss) var dismiss
    @State var profile: UserProfile
    @ObservedObject var viewModel: ProfileViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            HStack {
                Button("") {
                    dismiss()
                }
                .opacity(0) // Hidden but maintains spacing
                
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
                    
                    // Form Fields
                    VStack(spacing: 16) {
                        // First Name Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("First Name")
                                .font(.subheadline)
                                .foregroundColor(.textColor)
                                .padding(.horizontal, 4)
                            
                            HStack {
                                TextField("Enter your first name", text: $profile.firstName)
                                
                                if !profile.firstName.isEmpty {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.actionColor)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.cardSurface)
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.08), radius: 12, x: 0, y: 4)
                        }
                        
                        // Last Name Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Last Name")
                                .font(.subheadline)
                                .foregroundColor(.textColor)
                                .padding(.horizontal, 4)
                            
                            HStack {
                                TextField("Enter your last name", text: $profile.lastName)
                                
                                if !profile.lastName.isEmpty {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.actionColor)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.cardSurface)
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.08), radius: 12, x: 0, y: 4)
                        }
                        
                        // Email Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Email")
                                .font(.subheadline)
                                .foregroundColor(.textColor)
                                .padding(.horizontal, 4)
                            
                            HStack {
                                TextField("Enter your email address", text: $profile.email)
                                    .keyboardType(.emailAddress)
                                    .textInputAutocapitalization(.never)
                                    .autocorrectionDisabled()
                                
                                if !profile.email.isEmpty {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.actionColor)
                                        .font(.caption)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.vertical, 12)
                            .background(Color.cardSurface)
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.08), radius: 12, x: 0, y: 4)
                        }
                        
                        // Location Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Location")
                                .font(.subheadline)
                                .foregroundColor(.textColor)
                                .padding(.horizontal, 4)
                            
                            LocationPicker(
                                selectedLocation: $profile.location,
                                hasCheckmark: !profile.location.isEmpty
                            )
                            .background(Color.cardSurface)
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.08), radius: 12, x: 0, y: 4)
                        }
                        
                        // Mobile Number Card
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Mobile Number")
                                .font(.subheadline)
                                .foregroundColor(.textColor)
                                .padding(.horizontal, 4)
                            
                            HStack(spacing: 8) {
                                // Country Code Picker
                                Menu {
                                    Button("+1") { profile.countryCode = "+1" }
                                    Button("+44") { profile.countryCode = "+44" }
                                    Button("+88") { profile.countryCode = "+88" }
                                    Button("+91") { profile.countryCode = "+91" }
                                } label: {
                                    HStack {
                                        Text(profile.countryCode)
                                        Image(systemName: "chevron.down")
                                            .font(.caption)
                                    }
                                    .foregroundColor(.textColor)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 12)
                                    .background(Color.cardSurface)
                                    .cornerRadius(8)
                                }
                                
                                // Phone Number Field
                                HStack {
                                    TextField("Enter your phone number", text: $profile.mobileNumber)
                                        .keyboardType(.phonePad)
                                    
                                    if !profile.mobileNumber.isEmpty {
                                        Image(systemName: "checkmark")
                                            .foregroundColor(.actionColor)
                                            .font(.caption)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.vertical, 12)
                                .background(Color.cardSurface)
                                .cornerRadius(8)
                            }
                            .background(Color.cardSurface)
                            .cornerRadius(12)
                            .shadow(color: Color.primary.opacity(0.08), radius: 12, x: 0, y: 4)
                        }
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 20)
                }
            }
        }
        .navigationBarHidden(true)
        .ignoresSafeArea(.keyboard) // Prevent keyboard from pushing background
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
                        colors: [Color.actionColor, Color.actionColor.opacity(0.7)],
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

struct FormField: View {
    let label: String
    @Binding var text: String
    var placeholder: String = ""
    var hasCheckmark: Bool = false
    var keyboardType: UIKeyboardType = .default
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(label)
                .font(.subheadline)
                .foregroundColor(.textColor)
            
            HStack {
                TextField(placeholder, text: $text)
                    .keyboardType(keyboardType)
                
                if hasCheckmark {
                    Image(systemName: "checkmark")
                        .foregroundColor(.actionColor)
                        .font(.caption)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(Color.cardSurface)
            .cornerRadius(8)
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(profile: UserProfile.sampleProfile, viewModel: ProfileViewModel())
    }
}
