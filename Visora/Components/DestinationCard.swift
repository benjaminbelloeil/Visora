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
    @State private var navigateToDetail = false
    
    var body: some View {
        ZStack {
            // Main card background - tappable for navigation
            NavigationLink(destination: DestinationDetailView(destination: destination), isActive: $navigateToDetail) {
                EmptyView()
            }
            .opacity(0)
            
            // Card content
            ZStack {
                // Main card background
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 268, height: 384)
                    .background(Color.cardSurface)
                    .cornerRadius(24)
                    .shadow(
                        color: Color.primary.opacity(0.08),
                        radius: 12,
                        x: 0,
                        y: 4
                    )
                    .onTapGesture {
                        navigateToDetail = true
                    }
            
            // Destination Image
            Image(destination.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 240, height: 286)
                .clipped()
                .cornerRadius(20)
                .offset(x: 0, y: -35)
                .onTapGesture {
                    navigateToDetail = true
                }
                .onTapGesture(count: 2) {
                    // Double tap to bookmark
                    withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                        isBookmarked.toggle()
                        
                        // Provide haptic feedback
                        let generator = UINotificationFeedbackGenerator()
                        generator.notificationOccurred(isBookmarked ? .success : .warning)
                        
                        // Save to UserDefaults
                        saveBookmarkState()
                    }
                }
            
            // Bookmark button background
            Rectangle()
                .foregroundColor(.clear)
                .frame(width: 44, height: 44)
                .background(Color.primary.opacity(0.3))
                .cornerRadius(20)
                .offset(x: 89, y: -147)
            
            // Bookmark icon - completely independent with high priority gesture
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isBookmarked.toggle()
                    
                    // Provide haptic feedback
                    let generator = UIImpactFeedbackGenerator(style: .medium)
                    generator.impactOccurred()
                    
                    // Save to UserDefaults
                    saveBookmarkState()
                }
            } label: {
                Image(systemName: isBookmarked ? "bookmark.fill" : "bookmark")
                    .foregroundColor(.white)
                    .font(.system(size: 16, weight: .medium))
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: 44, height: 44)
            .contentShape(Rectangle())
            .offset(x: 89, y: -147)
            .zIndex(100)
            .simultaneousGesture(
                TapGesture()
                    .onEnded { _ in
                        // This prevents the tap from propagating
                    }
            )
            
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
        }
        .frame(width: 268, height: 384)
        .onAppear {
            loadBookmarkState()
        }
        .onReceive(NotificationCenter.default.publisher(for: .bookmarksDidChange)) { _ in
            // Update bookmark state when changes happen from other sources
            loadBookmarkState()
        }
    }
    
    // Save bookmark state to iCloud
    private func saveBookmarkState() {
        if isBookmarked {
            BookmarkManager.shared.addBookmark(destination.id)
        } else {
            BookmarkManager.shared.removeBookmark(destination.id)
        }
    }
    
    // Load bookmark state from iCloud
    private func loadBookmarkState() {
        isBookmarked = BookmarkManager.shared.isBookmarked(destination.id)
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

