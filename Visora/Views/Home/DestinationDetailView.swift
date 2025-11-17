//
//  DestinationDetailView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import MapKit

struct DestinationDetailView: View {
    let destination: Destination
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Hero image with parallax zoom effect and overlay text
                ZStack(alignment: .bottomLeading) {
                    GeometryReader { geometry in
                        let offset = geometry.frame(in: .global).minY
                        let imageHeight = 400 + max(offset, 0)
                        let screenWidth = geometry.size.width
                        
                        Image(destination.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: screenWidth, height: imageHeight)
                            .frame(height: 400, alignment: .bottom)
                    }
                    .frame(height: 400)
                    .clipped()
                    
                    // Full-width gradient overlay
                    LinearGradient(
                        colors: [Color.primary.opacity(0), Color.primary.opacity(0.4)],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: 400)
                    
                    // Title and location overlay on image
                    VStack(alignment: .leading, spacing: 8) {
                        Text(destination.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.and.ellipse")
                                .foregroundColor(.white)
                            Text(destination.country)
                                .foregroundColor(.white)
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(20)
                }
                .frame(height: 400)
                .clipped()
                
                VStack(alignment: .leading, spacing: 24) {
                    // Details Section - AI Analysis Style
                    VStack(alignment: .leading, spacing: 16) {
                        VStack(alignment: .leading, spacing: 12) {
                            // Key Facts from AI
                            if let fact1 = destination.fact1 {
                                InfoBullet(icon: "info.circle.fill", text: fact1, color: .blue)
                            }
                            if let fact2 = destination.fact2 {
                                InfoBullet(icon: "star.fill", text: fact2, color: Color(red: 1.0, green: 0.76, blue: 0.03))
                            }
                            if let fact3 = destination.fact3 {
                                InfoBullet(icon: "building.2.fill", text: fact3, color: .purple)
                            }
                        }
                        
                        // Full description
                        Text(destination.description)
                            .font(.custom("Nunito Sans", size: 16))
                            .foregroundColor(.subTextColor)
                            .lineSpacing(6)
                            .padding()
                            .background(Color.cardBackground)
                            .cornerRadius(12)
                    }
                    
                    // Location Map
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Location")
                            .font(.custom("Montserrat-Black", size: 22))
                            .foregroundColor(.textColor)
                        
                        Map(initialPosition: .region(MKCoordinateRegion(
                            center: destination.coordinate,
                            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                        ))) {
                            Marker(destination.name, coordinate: destination.coordinate)
                                .tint(Color(red: 1.0, green: 0.45, blue: 0.2))
                        }
                        .frame(height: 200)
                        .cornerRadius(20)
                        .tint(.actionColor)
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

#Preview {
    NavigationStack {
        DestinationDetailView(destination: Destination.sampleData[0])
    }
}
