//
//  AboutVisoraView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct AboutVisoraView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        List {
            // App Info Section
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 60))
                            .foregroundColor(.actionColor)
                        
                        Text("Visora")
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.subTextColor)
                    }
                    Spacer()
                }
                .padding(.vertical, 20)
            }
            .listRowBackground(Color.clear)
            
            // Description
            Section {
                Text("Visora is your intelligent travel companion that helps you discover and remember the world's most amazing monuments and places. Using cutting-edge AI technology, Visora identifies landmarks, provides historical context, and helps you organize your travel memories.")
                    .font(.subheadline)
                    .foregroundColor(.subTextColor)
            } header: {
                Text("About")
            }
            
            // Features
            Section {
                FeatureRow(
                    icon: "brain",
                    title: "AI Monument Recognition",
                    description: "Powered by Gemini AI"
                )
                
                FeatureRow(
                    icon: "map",
                    title: "Smart Location Tracking",
                    description: "Automatic GPS and geocoding"
                )
                
                FeatureRow(
                    icon: "calendar",
                    title: "Travel Timeline",
                    description: "Organize memories by date"
                )
                
                FeatureRow(
                    icon: "photo.stack",
                    title: "Photo Gallery",
                    description: "Beautiful collection of your travels"
                )
            } header: {
                Text("Features")
            }
            
            // Developer Info
            Section {
                HStack {
                    Text("Developer")
                        .foregroundColor(.subTextColor)
                    Spacer()
                    Text("Visora Team")
                }
                
                HStack {
                    Text("Release Date")
                        .foregroundColor(.subTextColor)
                    Spacer()
                    Text("November 2025")
                }
                
                HStack {
                    Text("Category")
                        .foregroundColor(.subTextColor)
                    Spacer()
                    Text("Travel & Photography")
                }
            } header: {
                Text("Information")
            }
            
            // Links
            Section {
                Link(destination: URL(string: "https://visora.com")!) {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.actionColor)
                        Text("Website")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Button {
                    // Open email
                    if let url = URL(string: "mailto:feedback@visora.com") {
                        UIApplication.shared.open(url)
                    }
                } label: {
                    HStack {
                        Image(systemName: "envelope")
                            .foregroundColor(.actionColor)
                        Text("Contact Us")
                            .foregroundColor(.textColor)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Button {
                    // Rate app
                } label: {
                    HStack {
                        Image(systemName: "star")
                            .foregroundColor(.actionColor)
                        Text("Rate Visora")
                            .foregroundColor(.textColor)
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
            } header: {
                Text("Connect")
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
                        content: termsContent
                    )
                } label: {
                    Text("Terms of Service")
                }
                
                NavigationLink {
                    LicensesView()
                } label: {
                    Text("Open Source Licenses")
                }
            } header: {
                Text("Legal")
            }
            
            // Credits
            Section {
                Text("© 2025 Visora. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.subTextColor)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.vertical, 8)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("About Visora")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .confirmationAction) {
                Button("Done") {
                    dismiss()
                }
            }
        }
    }
    
    private var privacyPolicyContent: String {
        """
        Privacy Policy for Visora
        
        Last Updated: November 16, 2025
        
        1. Introduction
        We respect your privacy and are committed to protecting your personal data.
        
        2. Data Collection
        We collect location data, photos, and usage information to provide our services.
        
        3. Data Usage
        Your data is used to identify monuments, provide recommendations, and improve our AI.
        
        4. Data Protection
        We use industry-standard encryption and security measures.
        
        5. Your Rights
        You can access, modify, or delete your data at any time.
        """
    }
    
    private var termsContent: String {
        """
        Terms of Service for Visora
        
        Last Updated: November 16, 2025
        
        1. Acceptance
        By using Visora, you agree to these terms.
        
        2. User Content
        You retain ownership of your photos and grant us permission to process them.
        
        3. Prohibited Uses
        Don't upload illegal or offensive content.
        
        4. Termination
        We may terminate accounts that violate these terms.
        """
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundColor(.actionColor)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.body)
                    .fontWeight(.medium)
                
                Text(description)
                    .font(.caption)
                    .foregroundColor(.subTextColor)
            }
        }
    }
}

struct LicensesView: View {
    var body: some View {
        List {
            Section {
                LicenseRow(
                    name: "Google Generative AI",
                    license: "Apache 2.0",
                    url: "https://github.com/google/generative-ai-swift"
                )
                
                LicenseRow(
                    name: "Swift",
                    license: "Apache 2.0",
                    url: "https://swift.org"
                )
            } header: {
                Text("Dependencies")
            }
            
            Section {
                Text("This app uses various open-source libraries and frameworks. We are grateful to the open-source community for their contributions.")
                    .font(.caption)
                    .foregroundColor(.subTextColor)
            }
        }
        .navigationTitle("Open Source Licenses")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct LicenseRow: View {
    let name: String
    let license: String
    let url: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(name)
                .font(.body)
                .fontWeight(.medium)
            
            HStack {
                Text(license)
                    .font(.caption)
                    .foregroundColor(.subTextColor)
                
                Spacer()
                
                Link(destination: URL(string: url)!) {
                    Image(systemName: "arrow.up.right.square")
                        .font(.caption)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        AboutVisoraView()
    }
}
