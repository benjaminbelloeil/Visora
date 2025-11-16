//
//  PreviousAnalysisView.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct PreviousAnalysisView: View {
    @StateObject private var calendarViewModel = CalendarViewModel.shared
    @State private var allPhotos: [PhotoEntry] = []
    @State private var searchText = ""
    
    var body: some View {
        Group {
            if filteredPhotos.isEmpty {
                emptyState
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredPhotos) { photo in
                            NavigationLink {
                                CalendarDayDetailView(photo: photo)
                            } label: {
                                AnalysisCard(photo: photo)
                            }
                            .buttonStyle(PlainButtonStyle())
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Previous Analysis")
        .navigationBarTitleDisplayMode(.inline)
        .searchable(text: $searchText, prompt: "Search locations, monuments...")
        .onAppear {
            loadAllPhotos()
        }
    }
    
    private var filteredPhotos: [PhotoEntry] {
        if searchText.isEmpty {
            return allPhotos
        } else {
            return allPhotos.filter { photo in
                (photo.locationName?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (photo.location?.localizedCaseInsensitiveContains(searchText) ?? false) ||
                (photo.aiDescription?.localizedCaseInsensitiveContains(searchText) ?? false)
            }
        }
    }
    
    private var emptyState: some View {
        VStack(spacing: 20) {
            Image(systemName: "photo.stack")
                .font(.system(size: 60))
                .foregroundColor(.subTextColor)
            
            Text("No Analysis Yet")
                .font(.title3)
                .fontWeight(.semibold)
            
            Text("Your analyzed photos will appear here")
                .font(.subheadline)
                .foregroundColor(.subTextColor)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 40)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    private func loadAllPhotos() {
        // Get all photos sorted by date (most recent first)
        allPhotos = calendarViewModel.photosByDate
            .sorted { $0.key > $1.key }
            .flatMap { $0.value }
    }
}

struct AnalysisCard: View {
    let photo: PhotoEntry
    
    var body: some View {
        HStack(spacing: 16) {
            // Photo Thumbnail
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.gray.opacity(0.2))
                    .frame(width: 100, height: 100)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                // Location Name
                if let locationName = photo.locationName {
                    Text(locationName)
                        .font(.headline)
                        .foregroundColor(.textColor)
                        .lineLimit(2)
                } else {
                    Text("Unknown Location")
                        .font(.headline)
                        .foregroundColor(.subTextColor)
                }
                
                // Location
                if let location = photo.location {
                    HStack(spacing: 4) {
                        Image(systemName: "mappin.circle.fill")
                            .font(.caption)
                            .foregroundColor(.actionColor)
                        Text(location)
                            .font(.subheadline)
                            .foregroundColor(.subTextColor)
                            .lineLimit(1)
                    }
                }
                
                // Date
                Text(photo.dateTaken.formatted(date: .abbreviated, time: .shortened))
                    .font(.caption)
                    .foregroundColor(.subTextColor)
                
                Spacer()
            }
            
            Spacer()
            
            // Chevron
            Image(systemName: "chevron.right")
                .font(.caption)
                .foregroundColor(.subTextColor)
        }
        .padding()
        .background(Color(UIColor.secondarySystemBackground))
        .cornerRadius(12)
    }
}

#Preview {
    NavigationStack {
        PreviousAnalysisView()
    }
}
