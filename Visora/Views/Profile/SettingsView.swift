//
//  SettingsView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: ProfileViewModel
    @StateObject private var appSettings = AppSettings.shared
    
    var body: some View {
        List {
            // Notifications Section
            Section {
                Toggle(isOn: $appSettings.notificationsEnabled) {
                    HStack {
                        Image(systemName: "bell.fill")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Push Notifications")
                    }
                }
                .onChange(of: appSettings.notificationsEnabled) { _, newValue in
                    viewModel.userProfile.preferences.enableNotifications = newValue
                    viewModel.saveProfile()
                }
                
                Toggle(isOn: $appSettings.locationServicesEnabled) {
                    HStack {
                        Image(systemName: "location.fill")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Location Services")
                    }
                }
                .onChange(of: appSettings.locationServicesEnabled) { _, newValue in
                    viewModel.userProfile.preferences.shareLocation = newValue
                    viewModel.saveProfile()
                }
            } header: {
                Text("General")
            }
            
            // Appearance Section
            Section {
                Picker(selection: $viewModel.userProfile.preferences.theme) {
                    Text("System").tag("system")
                    Text("Light").tag("light")
                    Text("Dark").tag("dark")
                } label: {
                    HStack {
                        Image(systemName: "moon.fill")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Appearance")
                    }
                }
                .onChange(of: viewModel.userProfile.preferences.theme) { _, newValue in
                    switch newValue {
                    case "dark":
                        appSettings.colorScheme = .dark
                    case "light":
                        appSettings.colorScheme = .light
                    default:
                        appSettings.colorScheme = nil
                    }
                    viewModel.saveProfile()
                }
                
                Picker(selection: $viewModel.userProfile.preferences.preferredLanguage) {
                    Text("English").tag("en")
                    Text("Spanish").tag("es")
                    Text("French").tag("fr")
                    Text("German").tag("de")
                    Text("Italian").tag("it")
                } label: {
                    HStack {
                        Image(systemName: "globe")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Language")
                    }
                }
                .onChange(of: viewModel.userProfile.preferences.preferredLanguage) { _, _ in
                    viewModel.saveProfile()
                }
            } header: {
                Text("Appearance")
            }
            
            // Privacy & Security Section
            Section {
                NavigationLink {
                    PrivacyView(viewModel: viewModel)
                } label: {
                    HStack {
                        Image(systemName: "lock.shield.fill")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Privacy")
                            .foregroundColor(.textColor)
                    }
                }
            } header: {
                Text("Privacy & Security")
            }
            
            // Support Section
            Section {
                NavigationLink {
                    HelpSupportView()
                } label: {
                    HStack {
                        Image(systemName: "questionmark.circle.fill")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Help & Support")
                            .foregroundColor(.textColor)
                    }
                }
            } header: {
                Text("Support")
            }
            
            // About Section
            Section {
                NavigationLink {
                    VersionView()
                } label: {
                    HStack {
                        Image(systemName: "info.circle.fill")
                            .foregroundColor(.actionColor)
                            .frame(width: 24)
                        Text("Version")
                            .foregroundColor(.textColor)
                    }
                }
            } header: {
                Text("About")
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        SettingsView(viewModel: ProfileViewModel())
    }
}
