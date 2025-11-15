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
                // Photo with parallax effect (matching DestinationDetailView)
                ZStack(alignment: .bottomLeading) {
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .global).minY
                        let imageHeight = 400 + max(offset, 0)
                        
                        if let image = photoEntry.image {
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
                        if let locationName = photoEntry.locationName {
                            Text(locationName)
                                .font(.title)
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                        }
                        
                        if let location = photoEntry.location {
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
                    
                    // Close button (top right)
                    VStack {
                        HStack {
                            Spacer()
                            Button(action: {
                                viewModel.reset()
                            }) {
                                ZStack {
                                    Circle()
                                        .fill(Color.black.opacity(0.3))
                                        .frame(width: 40, height: 40)
                                    
                                    Image(systemName: "xmark")
                                        .font(.system(size: 16, weight: .semibold))
                                        .foregroundColor(.white)
                                }
                            }
                            .padding(.top, 60)
                            .padding(.trailing, 20)
                        }
                        Spacer()
                    }
                }
                .frame(height: 400)
                .clipped()
                
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
                                .background(Color.cardBackground)
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
                        .background(Color.cardSurface)
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
                        .background(Color.cardSurface)
                        .cornerRadius(12)
                        .shadow(color: .black.opacity(0.05), radius: 8, x: 0, y: 2)
                    }
                    
                    // Action button
                    Button {
                        viewModel.saveToPhotoLibrary()
                    } label: {
                        HStack {
                            if viewModel.saveSuccess {
                                Image(systemName: "checkmark.circle.fill")
                                Text("Saved!")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.semibold)
                            } else {
                                Image(systemName: "square.and.arrow.down.fill")
                                Text("Save to Gallery")
                                    .font(.custom("Inter", size: 16))
                                    .fontWeight(.semibold)
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(viewModel.saveSuccess ? Color.green : Color(red: 1.0, green: 0.45, blue: 0.2))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                    }
                    .disabled(viewModel.saveSuccess)
                    
                    // Error message if save failed
                    if let error = viewModel.saveError {
                        Text(error)
                            .font(.custom("Inter", size: 14))
                            .foregroundColor(.red)
                            .padding(.top, 8)
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
        .background(Color.appBackground)
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
