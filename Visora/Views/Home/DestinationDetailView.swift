//
//  DestinationDetailView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct DestinationDetailView: View {
    let destination: Destination
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Hero image
                Rectangle()
                    .fill(Color.gray.opacity(0.3))
                    .frame(height: 300)
                    .overlay(
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                    )
                    .clipped()
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title and location
                    Text(destination.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    HStack {
                        Image(systemName: "mappin.and.ellipse")
                        Text(destination.country)
                    }
                    .foregroundColor(.secondary)
                    
                    Divider()
                    
                    // Description
                    Text("About")
                        .font(.headline)
                    
                    Text(destination.description)
                        .foregroundColor(.secondary)
                    
                    // Additional details
                    if let category = destination.category {
                        HStack {
                            Image(systemName: "tag.fill")
                            Text(category)
                        }
                        .padding(.top, 8)
                        .foregroundColor(.accentColor)
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
}

#Preview {
    NavigationStack {
        DestinationDetailView(destination: Destination.sampleData[0])
    }
}
