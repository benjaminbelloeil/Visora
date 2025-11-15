//
//  CalendarDayDetailView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct CalendarDayDetailView: View {
    let photo: PhotoEntry
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Photo with parallax effect (matching PhotoResultView)
                ZStack(alignment: .bottomLeading) {
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .global).minY
                        let imageHeight = 400 + max(offset, 0)
                        
                        if let image = photo.image {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: UIScreen.main.bounds.width, height: imageHeight)
                                .frame(height: 400, alignment: .bottom)
                        }
                    }
                    .frame(height: 400)
                    .clipped()
                    
                    // Full-width gradient overlay
                    LinearGradient(
                        colors: [Color.black.opacity(0), Color.black.opacity(0.6)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 400)
                    
                    // Location info overlay
                    VStack(alignment: .leading, spacing: 8) {
                        if let locationName = photo.locationName {
                            Text(locationName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        if let location = photo.location {
                            HStack(spacing: 4) {
                                Image(systemName: "mappin.and.ellipse")
                                    .foregroundColor(.white)
                                Text(location)
                                    .foregroundColor(.white)
                            }
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                }
                .frame(height: 400)
                .clipped()
                
                VStack(alignment: .leading, spacing: 24) {
                    // AI Analysis Section - ChatGPT style
                    if let aiDescription = photo.aiDescription {
                        VStack(alignment: .leading, spacing: 16) {
                            HStack(spacing: 8) {
                                ZStack {
                                    Circle()
                                        .fill(
                                            LinearGradient(
                                                colors: [Color(red: 1.0, green: 0.45, blue: 0.2), Color(red: 1.0, green: 0.6, blue: 0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(width: 32, height: 32)
                                    
                                    Image(systemName: "sparkles")
                                        .foregroundColor(.white)
                                        .font(.system(size: 14, weight: .semibold))
                                }
                                
                                Text("AI Analysis")
                                    .font(.custom("Montserrat-Black", size: 20))
                                    .foregroundColor(.textColor)
                            }
                            
                            VStack(alignment: .leading, spacing: 12) {
                                // Key Facts from AI
                                if let fact1 = photo.fact1 {
                                    InfoBullet(icon: "info.circle.fill", text: fact1, color: .blue)
                                }
                                if let fact2 = photo.fact2 {
                                    InfoBullet(icon: "star.fill", text: fact2, color: Color(red: 1.0, green: 0.76, blue: 0.03))
                                }
                                if let fact3 = photo.fact3 {
                                    InfoBullet(icon: "building.2.fill", text: fact3, color: .purple)
                                }
                            }
                            
                            // Full description
                            Text(aiDescription)
                                .font(.custom("Nunito Sans", size: 16))
                                .foregroundColor(.subTextColor)
                                .lineSpacing(6)
                                .padding()
                                .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                                .cornerRadius(12)
                        }
                    }
                    
                    // Quick Info Cards
                    HStack(spacing: 12) {
                        // Date Card
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "calendar")
                                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                                    .font(.system(size: 16))
                                Text("Date")
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(.subTextColor)
                            }
                            
                            Text(photo.dateTaken, style: .date)
                                .font(.custom("Inter", size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.textColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                        
                        // Time Card
                        VStack(alignment: .leading, spacing: 8) {
                            HStack(spacing: 6) {
                                Image(systemName: "clock")
                                    .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                                    .font(.system(size: 16))
                                Text("Time")
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(.subTextColor)
                            }
                            
                            Text(photo.dateTaken, style: .time)
                                .font(.custom("Inter", size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.textColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.cardBackground)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                }
                .padding(20)
            }
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.cardBackground)
    }
}

#Preview {
    NavigationStack {
        CalendarDayDetailView(photo: PhotoEntry.sampleData[0])
    }
}
