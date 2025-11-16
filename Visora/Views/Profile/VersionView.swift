//
//  VersionView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct VersionView: View {
    var body: some View {
        List {
            // Current Version
            Section {
                HStack {
                    Spacer()
                    VStack(spacing: 12) {
                        Image(systemName: "camera.viewfinder")
                            .font(.system(size: 50))
                            .foregroundColor(.actionColor)
                        
                        Text("Visora")
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        Text("Version 1.0.0")
                            .font(.subheadline)
                            .foregroundColor(.subTextColor)
                        
                        Text("Build 100")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                    .padding(.vertical, 20)
                    Spacer()
                }
            }
            .listRowBackground(Color.clear)
            
            // Version Info
            Section {
                InfoRow(label: "Release Date", value: "November 2025")
                InfoRow(label: "Latest Update", value: "November 16, 2025")
                InfoRow(label: "Platform", value: "iOS 16.0+")
            } header: {
                Text("Version Information")
            }
            
            // What's New
            Section {
                VStack(alignment: .leading, spacing: 12) {
                    FeatureBullet(text: "AI-powered monument recognition using Gemini AI")
                    FeatureBullet(text: "Smart location tracking with geocoding")
                    FeatureBullet(text: "Interactive map with photo annotations")
                    FeatureBullet(text: "Beautiful calendar view for travel memories")
                    FeatureBullet(text: "Gesture-based photo navigation")
                    FeatureBullet(text: "Comprehensive profile and settings")
                }
            } header: {
                Text("What's New in 1.0.0")
            }
            
            // System Info
            Section {
                InfoRow(label: "Device", value: UIDevice.current.model)
                InfoRow(label: "iOS Version", value: UIDevice.current.systemVersion)
                InfoRow(label: "Bundle ID", value: "com.visora.app")
            } header: {
                Text("System Information")
            }
            
            // Links
            Section {
                Link(destination: URL(string: "https://visora.com/release-notes")!) {
                    HStack {
                        Image(systemName: "doc.text")
                            .foregroundColor(.actionColor)
                        Text("Release Notes")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Link(destination: URL(string: "https://visora.com/roadmap")!) {
                    HStack {
                        Image(systemName: "map")
                            .foregroundColor(.actionColor)
                        Text("Roadmap")
                        Spacer()
                        Image(systemName: "arrow.up.right")
                            .font(.caption)
                            .foregroundColor(.subTextColor)
                    }
                }
                
                Button {
                    checkForUpdates()
                } label: {
                    HStack {
                        Image(systemName: "arrow.down.circle")
                            .foregroundColor(.actionColor)
                        Text("Check for Updates")
                            .foregroundColor(.textColor)
                        Spacer()
                    }
                }
            } header: {
                Text("Updates")
            }
            
            // Legal
            Section {
                Text("© 2025 Visora. All rights reserved.")
                    .font(.caption)
                    .foregroundColor(.subTextColor)
                    .frame(maxWidth: .infinity, alignment: .center)
            }
            .listRowBackground(Color.clear)
        }
        .navigationTitle("Version")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func checkForUpdates() {
        // In a real app, check App Store for updates
        // For now, just show an alert
    }
}

struct FeatureBullet: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: "checkmark.circle.fill")
                .foregroundColor(.actionColor)
                .font(.caption)
            
            Text(text)
                .font(.subheadline)
                .foregroundColor(.textColor)
        }
    }
}

#Preview {
    NavigationStack {
        VersionView()
    }
}
