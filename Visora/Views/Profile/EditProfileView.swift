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
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    
    var body: some View {
        Form {
            Section {
                HStack {
                    Spacer()
                    profileImagePicker
                    Spacer()
                }
                .padding(.vertical)
            }
            .listRowBackground(Color.clear)
            
            Section("Personal Information") {
                TextField("Name", text: $profile.name)
                TextField("Bio", text: Binding(
                    get: { profile.bio ?? "" },
                    set: { profile.bio = $0.isEmpty ? nil : $0 }
                ), axis: .vertical)
                .lineLimit(3...6)
            }
            
            Section("Preferences") {
                Toggle("Enable Notifications", isOn: $profile.preferences.enableNotifications)
                Toggle("Share Location", isOn: $profile.preferences.shareLocation)
            }
        }
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Save") {
                    // Save profile logic
                    dismiss()
                }
            }
        }
        .onChange(of: selectedItem) { _, newValue in
            Task {
                if let newValue = newValue,
                   let data = try? await newValue.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    selectedImage = image
                    // TODO: Save image and update profile.profileImageName
                }
            }
        }
    }
    
    private var profileImagePicker: some View {
        PhotosPicker(selection: $selectedItem, matching: .images) {
            Circle()
                .fill(Color.accentColor.opacity(0.3))
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
                            .foregroundColor(.accentColor)
                    }
                }
                .overlay(alignment: .bottomTrailing) {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                        .padding(8)
                        .background(Color.accentColor)
                        .clipShape(Circle())
                }
        }
    }
}

#Preview {
    NavigationStack {
        EditProfileView(profile: UserProfile.sampleProfile)
    }
}
