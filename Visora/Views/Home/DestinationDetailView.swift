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
                        let imageHeight = 300 + max(offset, 0)
                        
                        Image(destination.imageName)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: UIScreen.main.bounds.width, height: imageHeight)
                            .frame(height: 300, alignment: .bottom)
                    }
                    .frame(height: 300)
                    .clipped()
                    
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
                    .padding(20)
                    .background(
                        LinearGradient(
                            colors: [Color.black.opacity(0), Color.black.opacity(0.6)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                }
                .frame(height: 300)
                .clipped()
                
                VStack(alignment: .leading, spacing: 24) {
                    // About Section
                    VStack(alignment: .leading, spacing: 12) {
                        Text("About")
                            .font(.custom("Montserrat-Black", size: 22))
                            .foregroundColor(.textColor)
                        
                        VStack(alignment: .leading, spacing: 8) {
                            BulletPoint(text: getBulletPoint1())
                            BulletPoint(text: getBulletPoint2())
                            BulletPoint(text: getBulletPoint3())
                        }
                    }
                    
                    // Details Section
                    VStack(alignment: .leading, spacing: 16) {
                        Text("Details")
                            .font(.custom("Montserrat-Black", size: 22))
                            .foregroundColor(.textColor)
                        
                        // Category
                        if let category = destination.category {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 1.0, green: 0.45, blue: 0.2).opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "tag.fill")
                                        .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                                        .font(.system(size: 18))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Category")
                                        .font(.custom("Nunito Sans", size: 14))
                                        .foregroundColor(.subTextColor)
                                    Text(category)
                                        .font(.custom("Inter", size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textColor)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // Rating
                        if let rating = destination.rating {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color(red: 1.0, green: 0.76, blue: 0.03).opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "star.fill")
                                        .foregroundColor(Color(red: 1.0, green: 0.76, blue: 0.03))
                                        .font(.system(size: 18))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Rating")
                                        .font(.custom("Nunito Sans", size: 14))
                                        .foregroundColor(.subTextColor)
                                    Text(String(format: "%.1f / 5.0", rating))
                                        .font(.custom("Inter", size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textColor)
                                }
                                
                                Spacer()
                            }
                        }
                        
                        // Visitors
                        if let visitorCount = destination.visitorCount {
                            HStack(spacing: 12) {
                                ZStack {
                                    Circle()
                                        .fill(Color.blue.opacity(0.1))
                                        .frame(width: 44, height: 44)
                                    Image(systemName: "person.2.fill")
                                        .foregroundColor(.blue)
                                        .font(.system(size: 18))
                                }
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("Visitors")
                                        .font(.custom("Nunito Sans", size: 14))
                                        .foregroundColor(.subTextColor)
                                    Text("\(visitorCount)+ people")
                                        .font(.custom("Inter", size: 16))
                                        .fontWeight(.semibold)
                                        .foregroundColor(.textColor)
                                }
                                
                                Spacer()
                            }
                        }
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
                    }
                }
                .padding(20)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .ignoresSafeArea(edges: .top)
    }
    
    // Helper functions to get bullet points based on destination
    private func getBulletPoint1() -> String {
        switch destination.name {
        case "Eiffel Tower":
            return "Iconic 330-meter iron tower built in 1889 for the World's Fair"
        case "Athens":
            return "Historic capital with 3,400 years of civilization and democracy's birthplace"
        case "Colosseum":
            return "Largest ancient amphitheater built between 70-80 AD"
        default:
            return "Amazing destination worth visiting"
        }
    }
    
    private func getBulletPoint2() -> String {
        switch destination.name {
        case "Eiffel Tower":
            return "Three observation levels with breathtaking panoramic views of Paris"
        case "Athens":
            return "Home to the magnificent Acropolis and iconic Parthenon temple"
        case "Colosseum":
            return "Could hold up to 80,000 spectators for gladiatorial contests"
        default:
            return "Rich history and culture"
        }
    }
    
    private func getBulletPoint3() -> String {
        switch destination.name {
        case "Eiffel Tower":
            return "Sparkles with 20,000 golden lights every evening"
        case "Athens":
            return "Charming Plaka neighborhood with authentic Greek tavernas"
        case "Colosseum":
            return "UNESCO World Heritage Site and New Seven Wonders of the World"
        default:
            return "Unforgettable experiences await"
        }
    }
}

// Bullet Point Component
struct BulletPoint: View {
    let text: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Text("•")
                .font(.custom("Nunito Sans", size: 16))
                .foregroundColor(Color(red: 1.0, green: 0.45, blue: 0.2))
                .fontWeight(.bold)
            
            Text(text)
                .font(.custom("Nunito Sans", size: 16))
                .foregroundColor(.subTextColor)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
    
    #Preview {
        NavigationStack {
            DestinationDetailView(destination: Destination.sampleData[0])
        }
    }
}
