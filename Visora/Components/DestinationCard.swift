//
//  DestinationCard.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct DestinationCard: View {
    let destination: Destination
    @State private var isBookmarked = false
    
    var body: some View {
        ZStack {
            // Main card background
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 268, height: 384)
                .background(Color.cardSurface)
                .cornerRadius(24)
                .shadow(
                    color: Color.black.opacity(0.08),
                    radius: 12,
                    x: 0,
                    y: 4
                )
            
            // Destination Image
            Image(destination.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 240, height: 286)
                .clipped()
                .cornerRadius(20)
                .offset(x: 0, y: -35)
            
            // Bookmark button background
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 34, height: 34)
                .background(Color.gray.opacity(0.6))
                .cornerRadius(20)
                .offset(x: 89, y: -147)
            
            // Bookmark icon
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isBookmarked.toggle()
                }
            } label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .frame(width: 34, height: 34)
            .offset(x: 89, y: -147)
            
            // Destination name
            HStack {
                Text(destination.name)
                    .font(Font.custom("SF Pro", size: 18))
                    .tracking(0.50)
                    .lineSpacing(24)
                    .foregroundColor(.textColor)
                Spacer()
            }
            .frame(width: 240)
            .offset(x: 0, y: 134)
            
            // Rating
            if let rating = destination.rating {
                HStack(spacing: 4) {
                    Image(systemName: "star.fill")
                        .foregroundColor(Color(red: 1.0, green: 0.76, blue: 0.03))
                        .font(.system(size: 12))
                    
                    Text(String(format: "%.1f", rating))
                        .font(Font.custom("Inter", size: 15))
                        .tracking(0.30)
                        .lineSpacing(20)
                        .foregroundColor(.textColor)
                }
                .offset(x: 102, y: 134)
            }
            
            // Location with pin icon
            HStack(spacing: 4) {
                Image(systemName: "mappin.circle.fill")
                    .foregroundColor(.subTextColor)
                    .font(.system(size: 14))
                
                Text(destination.country)
                    .font(Font.custom("Inter", size: 15))
                    .tracking(0.30)
                    .lineSpacing(20)
                    .foregroundColor(.subTextColor)
                
                Spacer()
            }
            .frame(width: 240)
            .offset(x: 0, y: 166)
            
            // Visitor avatars
            if let visitorCount = destination.visitorCount {
                Group {
                    // Avatar 1
                    Circle()
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 1.0, green: 0.45, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.3)],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 24, height: 24)
                        .overlay(
                            Circle()
                                .stroke(Color.white, lineWidth: 1.5)
                        )
                        .offset(x: 75, y: 166)
                    
                    // Avatar 2
                    if visitorCount > 1 {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.6)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1.5)
                            )
                            .offset(x: 88, y: 166)
                    }
                    
                    // Avatar 3
                    if visitorCount > 2 {
                        Circle()
                            .fill(
                                LinearGradient(
                                    colors: [Color(red: 1.0, green: 0.45, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.3)],
                                    startPoint: .topLeading,
                                    endPoint: .bottomTrailing
                                )
                            )
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1.5)
                            )
                            .offset(x: 102, y: 166)
                    }
                    
                    // +Count circle
                    if visitorCount > 3 {
                        Circle()
                            .fill(Color(red: 0.3, green: 0.3, blue: 0.35))
                            .frame(width: 24, height: 24)
                            .overlay(
                                Circle()
                                    .stroke(Color.white, lineWidth: 1.5)
                            )
                            .offset(x: 116, y: 166)
                        
                        Text("+\(visitorCount)")
                            .font(Font.custom("Inter", size: 8))
                            .fontWeight(.bold)
                            .lineSpacing(13)
                            .foregroundColor(.white)
                            .offset(x: 116, y: 166)
                    }
                }
            }
        }
        .frame(width: 268, height: 384)
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(spacing: 20) {
            ForEach(Destination.sampleData) { destination in
                DestinationCard(destination: destination)
            }
        }
        .padding()
    }
}

