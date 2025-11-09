//
//  PhotoCard.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct PhotoCard: View {
    let photo: PhotoEntry
    
    var body: some View {
        VStack {
            // Placeholder for photo - in a real app, you'd load from photo.imageName
            Rectangle()
                .fill(Color.gray.opacity(0.3))
                .aspectRatio(1, contentMode: .fit)
                .overlay(
                    Image(systemName: "photo")
                        .font(.title)
                        .foregroundColor(.gray)
                )
                .cornerRadius(8)
            
            if let caption = photo.caption {
                Text(caption)
                    .font(.caption)
                    .lineLimit(2)
                    .multilineTextAlignment(.center)
            }
        }
    }
}

#Preview {
    PhotoCard(photo: PhotoEntry.sampleData[0])
        .frame(width: 100, height: 120)
}
