//
//  CalendarDayDetailView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let date: Date
    let photos: [PhotoEntry]
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        return formatter
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Date header
                Text(dateFormatter.string(from: date))
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.horizontal)
                
                // Photos grid
                LazyVGrid(columns: [
                    GridItem(.flexible()),
                    GridItem(.flexible())
                ], spacing: 16) {
                    ForEach(photos) { photo in
                        VStack(alignment: .leading, spacing: 8) {
                            if let image = photo.image {
                                Image(uiImage: image)
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(height: 200)
                                    .clipped()
                                    .cornerRadius(12)
                            }
                            
                            if let locationName = photo.locationName {
                                HStack {
                                    Image(systemName: "mappin.circle.fill")
                                        .font(.caption)
                                    Text(locationName)
                                        .font(.caption)
                                        .lineLimit(1)
                                }
                                .foregroundColor(.secondary)
                            }
                            
                            if let aiDescription = photo.aiDescription {
                                Text(aiDescription)
                                    .font(.caption2)
                                    .foregroundColor(.secondary)
                                    .lineLimit(2)
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        CalendarDayDetailView(
            date: Date(),
            photos: PhotoEntry.sampleData
        )
    }
}
