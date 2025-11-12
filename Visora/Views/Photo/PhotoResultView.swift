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
            VStack(alignment: .leading, spacing: 0) {
                // Photo with overlay
                ZStack(alignment: .bottomLeading) {
                    if let image = photoEntry.image {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipped()
                    }
                    
                    // Gradient overlay
                    LinearGradient(
                        colors: [Color.black.opacity(0), Color.black.opacity(0.7)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 300)
                    
                    // Location badge
                    VStack(alignment: .leading, spacing: 4) {
                        if let locationName = photoEntry.locationName {
                            HStack(spacing: 8) {
                                Image(systemName: "mappin.circle.fill")
                                    .foregroundColor(.white)
                                Text(locationName)
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.semibold)
                                    .foregroundColor(.white)
                            }
                        }
                        
                        if let location = photoEntry.location {
                            HStack(spacing: 6) {
                                Image(systemName: "location.fill")
                                    .foregroundColor(.white.opacity(0.8))
                                    .font(.system(size: 12))
                                Text(location)
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.white.opacity(0.9))
                            }
                        }
                    }
                    .padding(.horizontal, 16)
                    .padding(.vertical, 10)
                    .background(Color.white.opacity(0.3))
                    .background(.ultraThinMaterial)
                    .cornerRadius(20)
                    .padding(20)
                }
                .frame(height: 300)
                
                VStack(alignment: .leading, spacing: 24) {
                    // AI Analysis Section - ChatGPT style
                    if let aiDescription = photoEntry.aiDescription {
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
                                if let fact1 = photoEntry.fact1 {
                                    InfoBullet(icon: "info.circle.fill", text: fact1, color: .blue)
                                }
                                if let fact2 = photoEntry.fact2 {
                                    InfoBullet(icon: "star.fill", text: fact2, color: Color(red: 1.0, green: 0.76, blue: 0.03))
                                }
                                if let fact3 = photoEntry.fact3 {
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
                            
                            Text(photoEntry.dateTaken, style: .date)
                                .font(.custom("Inter", size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.textColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
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
                            
                            Text(photoEntry.dateTaken, style: .time)
                                .font(.custom("Inter", size: 15))
                                .fontWeight(.semibold)
                                .foregroundColor(.textColor)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(Color.white)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                    
                    // Action buttons
                    VStack(spacing: 12) {
                        Button {
                            // Save photo logic
                            viewModel.reset()
                        } label: {
                            HStack {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text("Save to Gallery")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.semibold)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 1.0, green: 0.45, blue: 0.2))
                            .foregroundColor(.white)
                            .cornerRadius(12)
                        }
                        
                        Button {
                            viewModel.reset()
                        } label: {
                            HStack {
                                Image(systemName: "camera.fill")
                                Text("Take Another Photo")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.medium)
                            }
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color(red: 0.97, green: 0.97, blue: 0.98))
                            .foregroundColor(.textColor)
                            .cornerRadius(12)
                        }
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.white)
    }
}

// Info Bullet Component
struct InfoBullet: View {
    let icon: String
    let text: String
    let color: Color
    
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundColor(color)
                .font(.system(size: 14))
                .frame(width: 20)
            
            Text(text)
                .font(.custom("Nunito Sans", size: 15))
                .foregroundColor(.textColor)
        }
    }
}

#Preview {
    PhotoResultView(photoEntry: PhotoEntry.sampleData[0])
        .environmentObject(PhotoViewModel())
}
