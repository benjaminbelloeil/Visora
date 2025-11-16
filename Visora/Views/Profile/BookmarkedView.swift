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
            .padding(.horizontal)
            .padding(.top)
            .padding(.bottom, 8)
            
            // Content based on selected tab
            Group {
                if selectedTab == 0 {
                    // Bookmarked Destinations
                    if bookmarkedDestinations.isEmpty {
                        emptyDestinationsState
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 12) {
                                ForEach(bookmarkedDestinations) { destination in
                                    HorizontalDestinationCard(destination: destination)
                                }
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 12)
                            .padding(.bottom, 20)
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
        .onReceive(NotificationCenter.default.publisher(for: .bookmarksDidChange)) { _ in
            // Reload destinations when bookmarks change
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
        // Load bookmarked destination IDs from iCloud
        let bookmarkedIDs = BookmarkManager.shared.getBookmarkedDestinations()
        
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

struct HorizontalDestinationCard: View {
    let destination: Destination
    @State private var isBookmarked = false
    @State private var navigateToDetail = false
    @EnvironmentObject private var profileViewModel: ProfileViewModel
    
    var body: some View {
        NavigationLink(destination: DestinationDetailView(destination: destination), isActive: $navigateToDetail) {
            HStack(spacing: 16) {
                // Destination Image
                Image(destination.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 140, height: 180)
                    .clipped()
                    .cornerRadius(16)
                
                // Content
                VStack(alignment: .leading, spacing: 12) {
                    // Title
                    Text(destination.name)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.textColor)
                        .lineLimit(2)
                    
                    // Location
                    HStack(spacing: 6) {
                        Image(systemName: "info.circle")
                            .font(.system(size: 14))
                            .foregroundColor(.subTextColor)
                        Text(destination.country)
                            .font(.system(size: 15))
                            .foregroundColor(.subTextColor)
                    }
                    
                    // Rating
                    if let rating = destination.rating {
                        HStack(spacing: 6) {
                            Image(systemName: "star.fill")
                                .font(.system(size: 14))
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", rating))
                                .font(.system(size: 15, weight: .semibold))
                                .foregroundColor(.textColor)
                        }
                    }
                    
                    Spacer()
                    
                    // Bookmark button
                    Button {
                        withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                            isBookmarked.toggle()
                            
                            // Provide haptic feedback
                            let generator = UIImpactFeedbackGenerator(style: .medium)
                            generator.impactOccurred()
                            
                            // Save to UserDefaults
                            saveBookmarkState()
                        }
                    } label: {
                        HStack(spacing: 8) {
                            Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                            Text(isBookmarked ? "Bookmarked" : "Bookmark")
                        }
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(isBookmarked ? .actionColor : .subTextColor)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(isBookmarked ? Color.actionColor.opacity(0.1) : Color.gray.opacity(0.1))
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                .padding(.vertical, 16)
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity)
            .padding(16)
            .background(Color.cardSurface)
            .cornerRadius(16)
            .shadow(
                color: Color.primary.opacity(0.08),
                radius: 8,
                x: 0,
                y: 2
            )
        }
        .buttonStyle(PlainButtonStyle())
        .onAppear {
            // Load bookmark state from iCloud
            isBookmarked = BookmarkManager.shared.isBookmarked(destination.id)
        }
        .onReceive(NotificationCenter.default.publisher(for: .bookmarksDidChange)) { _ in
            // Update bookmark state when changes happen
            isBookmarked = BookmarkManager.shared.isBookmarked(destination.id)
        }
    }
    
    private func saveBookmarkState() {
        if isBookmarked {
            BookmarkManager.shared.addBookmark(destination.id)
        } else {
            BookmarkManager.shared.removeBookmark(destination.id)
        }
    }
}

#Preview {
    NavigationStack {
        BookmarkedView()
    }
}
