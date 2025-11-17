//
//  HomeView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import MapKit

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel.shared
    @StateObject private var profileViewModel = ProfileViewModel()
    @State private var showNotifications = false
    @State private var showAllDestinations = false
    @Binding var selectedTab: Int
    
    init(selectedTab: Binding<Int> = .constant(0)) {
        self._selectedTab = selectedTab
    }
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // User Profile Header - synced with profile
                    UserProfileHeader(
                        userName: {
                            let firstName = profileViewModel.userProfile.firstName
                            let lastName = profileViewModel.userProfile.lastName
                            
                            if !firstName.isEmpty && !lastName.isEmpty {
                                return "\(firstName) \(lastName)"
                            } else if !firstName.isEmpty {
                                return firstName
                            } else if !lastName.isEmpty {
                                return lastName
                            } else if !profileViewModel.userProfile.name.isEmpty {
                                return profileViewModel.userProfile.name
                            } else {
                                return "Traveler"
                            }
                        }(),
                        profileImage: profileViewModel.userProfile.profileImage,
                        hasNotification: true,
                        onNotificationTap: {
                            showNotifications = true
                        },
                        onProfileTap: {
                            selectedTab = 4 // Navigate to Profile tab
                        }
                    )
                    .padding(.horizontal, 20)
                    
                    // Hero Title Section
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Explore the")
                            .font(.custom("Montserrat", size: 42))
                            .fontWeight(.medium)
                            .foregroundColor(.textColor)
                        
                        HStack(spacing: 12) {
                            Text("Beautiful")
                                .font(.custom("Montserrat-Black", size: 42))
                                .foregroundColor(.textColor)
                            
                            ZStack(alignment: .bottom) {
                                Text("world!")
                                    .font(.custom("Montserrat", size: 42))
                                    .fontWeight(.black)
                                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                                
                                CurvedUnderline()
                                    .fill(Color(red: 1.0, green: 0.45, blue: 0.2))
                                    .frame(width: 110, height: 10)
                                    .offset(y: 19)
                            }
                        }
                    }
                    .padding(.horizontal, 15)
                    
                    // Best Destination Section
                    VStack(alignment: .leading, spacing: 20) {
                        // Section header
                        HStack {
                            Text("Best Destination")
                                .font(.custom("Montserrat-Black", size: 22))
                                .foregroundColor(.textColor)
                            
                            Spacer()
                            
                            Button {
                                showAllDestinations = true
                            } label: {
                                Text("View all")
                                    .font(.custom("Nunito Sans", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                            }
                        }
                        .padding(.horizontal, 15)
                        
                        // Horizontal scrolling destinations
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 20) {
                                ForEach(viewModel.featuredDestinations) { destination in
                                    DestinationCard(destination: destination)
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 20)
                            .padding(.bottom, 30)
                        }
                        .padding(.leading, 0)
                    }
                    
                    // Visited Location Section
                    VStack(alignment: .leading, spacing: 20) {
                        // Section header
                        HStack {
                            Text("Visited Location")
                                .font(.custom("Montserrat-Black", size: 22))
                                .foregroundColor(.textColor)
                            
                            Spacer()
                            
                            Button {
                                selectedTab = 3 // Switch to Map tab
                            } label: {
                                Text("View all")
                                    .font(.custom("Nunito Sans", size: 16))
                                    .fontWeight(.medium)
                                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                            }
                        }
                        .padding(.horizontal, 15)
                        
                        // Map preview showing actual calendar photos
                        let calendarPhotos = CalendarViewModel.shared.photosByDate.values.flatMap { $0 }.filter { $0.coordinate != nil }
                        
                        if !calendarPhotos.isEmpty {
                            // Calculate center of all photos
                            let coordinates = calendarPhotos.compactMap { $0.coordinate }
                            let centerLat = coordinates.map { $0.latitude }.reduce(0, +) / Double(coordinates.count)
                            let centerLon = coordinates.map { $0.longitude }.reduce(0, +) / Double(coordinates.count)
                            
                            Map(initialPosition: .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: centerLat, longitude: centerLon),
                                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
                            ))) {
                                ForEach(calendarPhotos) { photo in
                                    if let coordinate = photo.coordinate {
                                        Marker(photo.locationName ?? "Unknown", coordinate: coordinate)
                                            .tint(Color(red: 1.0, green: 0.45, blue: 0.2))
                                    }
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(20)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                selectedTab = 3 // Switch to Map tab
                            }
                            .allowsHitTesting(true)
                        } else {
                            // Show sample destinations if no photos yet
                            Map(initialPosition: .region(MKCoordinateRegion(
                                center: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
                                span: MKCoordinateSpan(latitudeDelta: 15, longitudeDelta: 15)
                            ))) {
                                ForEach(viewModel.featuredDestinations) { destination in
                                    Marker(destination.name, coordinate: destination.coordinate)
                                        .tint(Color(red: 1.0, green: 0.45, blue: 0.2))
                                }
                            }
                            .frame(height: 200)
                            .cornerRadius(20)
                            .padding(.horizontal, 10)
                            .onTapGesture {
                                selectedTab = 3 // Switch to Map tab
                            }
                            .allowsHitTesting(true)
                        }
                    }
                }
                .padding(.vertical, -39)
                .padding(.bottom, 150) // Add padding to allow content to scroll under navbar
            }
            .ignoresSafeArea(edges: .bottom) // Allow content to extend under the navbar
            .background(Color.appBackground)
            .onAppear {
                // Only load if data hasn't been preloaded
                if viewModel.featuredDestinations.isEmpty {
                    viewModel.loadFeaturedDestinations()
                }
                profileViewModel.loadProfile() // Ensure profile is loaded
            }
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
            .sheet(isPresented: $showAllDestinations) {
                ViewAllDestinationsView()
            }
        }
    }
}

#Preview {
    HomeView()
}
