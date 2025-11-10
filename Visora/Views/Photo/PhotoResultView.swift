//
//  PhotoResultView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct PhotoResultView: View {
    let photoEntry: PhotoEntry
    @EnvironmentObject var viewModel: PhotoViewModel
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Photo
                if let image = photoEntry.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .cornerRadius(12)
                }
                
                VStack(alignment: .leading, spacing: 16) {
                    // AI Analysis
                    if let aiDescription = photoEntry.aiDescription {
                        VStack(alignment: .leading, spacing: 8) {
                            Label("AI Analysis", systemImage: "sparkles")
                                .font(.headline)
                            Text(aiDescription)
                                .foregroundColor(.subTextColor)
                        }
                        .padding()
                        .background(Color.actionColor.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Location
                    if let locationName = photoEntry.locationName {
                        HStack {
                            Image(systemName: "mappin.circle.fill")
                                .foregroundColor(.red)
                            VStack(alignment: .leading) {
                                Text("Location")
                                    .font(.caption)
                                    .foregroundColor(.subTextColor)
                                Text(locationName)
                                    .font(.body)
                            }
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .cornerRadius(12)
                    }
                    
                    // Date
                    HStack {
                        Image(systemName: "calendar")
                            .foregroundColor(.blue)
                        VStack(alignment: .leading) {
                            Text("Date")
                                .font(.caption)
                                .foregroundColor(.subTextColor)
                            Text(photoEntry.dateTaken, style: .date)
                                .font(.body)
                        }
                    }
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .cornerRadius(12)
                    
                    // Action buttons
                    HStack(spacing: 12) {
                        PrimaryButton(title: "Save") {
                            // Save photo logic
                            viewModel.reset()
                        }
                        
                        Button("Retake") {
                            viewModel.reset()
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .foregroundColor(.primary)
                        .cornerRadius(12)
                    }
                }
            }
            .padding()
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    PhotoResultView(photoEntry: PhotoEntry.sampleData[0])
        .environmentObject(PhotoViewModel())
}
