//
//  DestinationCard.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct DestinationCard: View {
    let destination: Destination
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image placeholder
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .frame(height: 200)
                .overlay(
                    Image(systemName: "photo.on.rectangle.angled")
                        .font(.system(size: 40))
                        .foregroundColor(.gray)
                )
            
            VStack(alignment: .leading, spacing: 8) {
                HStack {
                    Text(destination.name)
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    Spacer()
                    
                    Text(destination.country)
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(Color.actionColor.opacity(0.1))
                        .foregroundColor(.actionColor)
                        .cornerRadius(4)
                }
                
                Text(destination.description)
                    .font(.subheadline)
                    .foregroundColor(.subTextColor)
                    .lineLimit(2)
            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
    }
}

#Preview {
    DestinationCard(destination: Destination.sampleData[0])
        .padding()
}
