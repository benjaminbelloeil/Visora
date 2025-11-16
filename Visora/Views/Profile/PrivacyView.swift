//
//  PrivacyView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct PrivacyView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var appSettings = AppSettings.shared
    @State private var showDeleteConfirmation = false
    
    var body: some View {
        List {
            // Location Privacy
            Section {
                Toggle(isOn: $appSettings.locationServicesEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Share Location")
                            .font(.body)
                        Text("Allow Visora to access your location for better recommendations")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                .onChange(of: appSettings.locationServicesEnabled) { _, newValue in
                    viewModel.userProfile.preferences.shareLocation = newValue
                    viewModel.saveProfile()
                }
                
                Toggle(isOn: .constant(true)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Location History")
                            .font(.body)
                        Text("Save location data for your photo memories")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
            } header: {
                Text("Location")
            } footer: {
                Text("Location data is used to enhance your travel experience and provide personalized recommendations.")
            }
            
            // Photo Privacy
            Section {
                Toggle(isOn: .constant(true)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Photo Analysis")
                            .font(.body)
                        Text("Use AI to identify monuments and locations")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Toggle(isOn: .constant(false)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Auto-Upload to Cloud")
                            .font(.body)
                        Text("Automatically backup photos to cloud storage")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
            } header: {
                Text("Photos")
            }
            
            // Data Privacy
            Section {
                Toggle(isOn: .constant(true)) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Analytics")
                            .font(.body)
                        Text("Help improve Visora by sharing anonymous usage data")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Toggle(isOn: $appSettings.notificationsEnabled) {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Personalized Recommendations")
                            .font(.body)
                        Text("Receive travel suggestions based on your preferences")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                .onChange(of: appSettings.notificationsEnabled) { _, newValue in
                    viewModel.userProfile.preferences.enableNotifications = newValue
                    viewModel.saveProfile()
                }
            } header: {
                Text("Data Collection")
            }
            
            // Account Privacy
            Section {
                NavigationLink {
                    DataManagementView()
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Download My Data")
                            .font(.body)
                        Text("Export all your Visora data")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Button(role: .destructive) {
                    showDeleteConfirmation = true
                } label: {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Delete Account")
                            .font(.body)
                        Text("Permanently delete your account and all data")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
            } header: {
                Text("Account Data")
            }
            
            // Legal
            Section {
                NavigationLink {
                    WebDocumentView(
                        title: "Privacy Policy",
                        content: privacyPolicyContent
                    )
                } label: {
                    Text("Privacy Policy")
                }
                
                NavigationLink {
                    WebDocumentView(
                        title: "Terms of Service",
                        content: termsOfServiceContent
                    )
                } label: {
                    Text("Terms of Service")
                }
            } header: {
                Text("Legal")
            }
        }
        .navigationTitle("Privacy")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
        .alert("Delete Account", isPresented: $showDeleteConfirmation) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                // Handle account deletion
            }
        } message: {
            Text("Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently deleted.")
        }
    }
    
    private var privacyPolicyContent: String {
        """
        Privacy Policy for Visora
        
        Last Updated: November 16, 2025
        
        1. Introduction
        Welcome to Visora. We respect your privacy and are committed to protecting your personal data.
        
        2. Data We Collect
        - Location data (with your permission)
        - Photos you capture or upload
        - Travel history and preferences
        - Device information
        
        3. How We Use Your Data
        - To identify monuments and locations in your photos
        - To provide personalized travel recommendations
        - To improve our AI recognition services
        - To enhance your overall experience
        
        4. Data Security
        We implement industry-standard security measures to protect your data.
        
        5. Your Rights
        You have the right to access, modify, or delete your personal data at any time.
        
        6. Contact Us
        For privacy concerns, contact us at privacy@visora.com
        """
    }
    
    private var termsOfServiceContent: String {
        """
        Terms of Service for Visora
        
        Last Updated: November 16, 2025
        
        1. Acceptance of Terms
        By using Visora, you agree to these Terms of Service.
        
        2. User Accounts
        You are responsible for maintaining the security of your account.
        
        3. Content
        - You retain ownership of photos you upload
        - You grant Visora permission to process your photos for AI analysis
        
        4. Prohibited Uses
        - Don't upload offensive or illegal content
        - Don't attempt to reverse engineer our services
        
        5. Termination
        We reserve the right to terminate accounts that violate these terms.
        
        6. Changes to Terms
        We may update these terms periodically. Continued use constitutes acceptance.
        
        7. Contact
        For questions, contact legal@visora.com
        """
    }
}

struct DataManagementView: View {
    @State private var isExporting = false
    
    var body: some View {
        List {
            Section {
                Text("Download a copy of all your data including photos, locations, and travel history.")
                    .font(.subheadline)
                    .foregroundColor(.subTextColor)
            }
            
            Section {
                Button {
                    isExporting = true
                    // Simulate export
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isExporting = false
                    }
                } label: {
                    HStack {
                        if isExporting {
                            ProgressView()
                                .padding(.trailing, 8)
                        }
                        Text(isExporting ? "Preparing Export..." : "Export My Data")
                    }
                }
                .disabled(isExporting)
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    InfoRow(label: "Photos", value: "1,247")
                    InfoRow(label: "Locations", value: "238")
                    InfoRow(label: "Account Age", value: "2 years")
                }
            } header: {
                Text("Data Summary")
            }
        }
        .navigationTitle("Data Management")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct InfoRow: View {
    let label: String
    let value: String
    
    var body: some View {
        HStack {
            Text(label)
                .foregroundColor(.subTextColor)
            Spacer()
            Text(value)
                .fontWeight(.semibold)
        }
    }
}

struct WebDocumentView: View {
    let title: String
    let content: String
    
    var body: some View {
        ScrollView {
            Text(content)
                .padding()
        }
        .navigationTitle(title)
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        PrivacyView(viewModel: ProfileViewModel())
    }
}
