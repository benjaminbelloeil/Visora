//
//  BookmarkedView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct BookmarkedView: View {
    @StateObject private var calendarViewModel = CalendarViewModel.shared
    @State private var bookmarkedPhotos: [PhotoEntry] = []
    @State private var bookmarkedDestinations: [Destination] = []
    @State private var selectedTab = 0
    
    var body: some View {
        VStack(spacing: 0) {
            // Segmented control for switching between destinations and photos
            Picker("Bookmarks", selection: $selectedTab) {
                Text("Destinations").tag(0)
                Text("Photos").tag(1)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            // Content based on selected tab
            Group {
                if selectedTab == 0 {
                    // Bookmarked Destinations
                    if bookmarkedDestinations.isEmpty {
                        emptyDestinationsState
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(bookmarkedDestinations) { destination in
                                    DestinationCard(destination: destination)
                                        .scaleEffect(0.65)
                                }
                            }
                            .padding()
                        }
                    }
                } else {
                    // Bookmarked Photos
                    if bookmarkedPhotos.isEmpty {
                        emptyPhotosState
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 16) {
                                ForEach(bookmarkedPhotos) { photo in
                                    BookmarkedPhotoCard(photo: photo)
                                }
                            }
                            .padding()
                        }
                    }
                }
            }
        }
        .navigationTitle("Bookmarked")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            loadBookmarkedPhotos()
            loadBookmarkedDestinations()
        }
    }
    
    private var emptyDestinationsState: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 60))
                .foregroundColor(.subTextColor)
            
            Text("No Bookmarked Destinations")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Tap the bookmark icon on any destination card or double-tap the image to save your favorite places here")
                .font(.subheadline)
                .foregroundColor(.subTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private var emptyPhotosState: some View {
        VStack(spacing: 20) {
            Image(systemName: "bookmark.slash")
                .font(.system(size: 60))
                .foregroundColor(.subTextColor)
            
            Text("No Bookmarked Photos")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Tap the bookmark icon on any photo to save your favorite memories here")
                .font(.subheadline)
                .foregroundColor(.subTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadBookmarkedDestinations() {
        // Load bookmarked destination IDs from UserDefaults
        let bookmarkedIDs = UserDefaults.standard.stringArray(forKey: "BookmarkedDestinations") ?? []
        
        // Filter destinations from sample data that are bookmarked
        bookmarkedDestinations = Destination.sampleData.filter { destination in
            bookmarkedIDs.contains(destination.id)
        }
    }
    
    private func loadBookmarkedPhotos() {
        // Load only favorited photos from CalendarViewModel
        let allPhotos = calendarViewModel.photosByDate.values.flatMap { $0 }
        bookmarkedPhotos = allPhotos.filter { $0.isFavorite }
    }
}

struct BookmarkedPhotoCard: View {
    let photo: PhotoEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Photo
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 150)
                    .clipped()
                    .cornerRadius(12)
            }
            
            // Location Name
            if let locationName = photo.locationName {
                Text(locationName)
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .lineLimit(2)
            }
            
            // Date
            Text(photo.dateTaken.formatted(date: .abbreviated, time: .omitted))
                .font(.caption)
                .foregroundColor(.subTextColor)
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkedView()
    }
}
