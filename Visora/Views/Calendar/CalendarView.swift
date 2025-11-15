//
//  CalendarView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct CalendarView: View {
    @ObservedObject var viewModel = CalendarViewModel.shared
    @State private var selectedDate = Date()
    @State private var showNotifications = false
    @State private var showAllPhotos = false
    
    private let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // Header with notification - Enhanced Title
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Calendar")
                                .font(.custom("Montserrat-Black", size: 36))
                                .foregroundColor(.textColor)
                            
                            // Decorative underline
                            Rectangle()
                                .fill(
                                    LinearGradient(
                                        colors: [Color.actionColor, Color.actionColor.opacity(0.4)],
                                        startPoint: .leading,
                                        endPoint: .trailing
                                    )
                                )
                                .frame(width: 80, height: 4)
                                .cornerRadius(2)
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            showNotifications = true
                        }) {
                            Circle()
                                .fill(Color(red: 0.97, green: 0.97, blue: 0.98))
                                .frame(width: 44, height: 44)
                                .overlay(
                                    ZStack {
                                        Image(systemName: "bell")
                                            .foregroundColor(.textColor)
                                        Circle()
                                            .fill(Color.red)
                                            .frame(width: 8, height: 8)
                                            .offset(x: 6, y: -6)
                                    }
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Calendar Week View
                    ZStack {
                        // Background card
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(maxWidth: .infinity)
                            .frame(height: 148)
                            .background(Color.white)
                            .cornerRadius(24)
                            .shadow(
                                color: Color.black.opacity(0.08),
                                radius: 12,
                                x: 0,
                                y: 4
                            )
                        
                        // Date title
                        Text(monthYearString(from: selectedDate))
                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                            .lineSpacing(28)
                            .foregroundColor(Color(red: 0.11, green: 0.12, blue: 0.16))
                            .offset(x: -97, y: -44)
                        
                        // Navigation arrows
                        HStack(spacing: 16) {
                            Button(action: {
                                selectedDate = Calendar.current.date(byAdding: .day, value: -7, to: selectedDate) ?? selectedDate
                            }) {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.actionColor)
                                    .frame(width: 24, height: 24)
                            }
                            
                            Button(action: {
                                selectedDate = Calendar.current.date(byAdding: .day, value: 7, to: selectedDate) ?? selectedDate
                            }) {
                                Image(systemName: "chevron.right")
                                    .foregroundColor(.actionColor)
                                    .frame(width: 24, height: 24)
                            }
                        }
                        .offset(x: 120, y: -44)
                        
                        // Week days and dates
                        let dates = weekDates()
                        ForEach(Array(dates.enumerated()), id: \.offset) { index, date in
                            let xPosition = -141 + Double(index) * 47
                            let day = Calendar.current.component(.day, from: date)
                            let isSelected = isToday(date)
                            
                            // Selection background
                            if isSelected {
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(width: 44, height: 76)
                                    .background(Color(red: 1, green: 0.44, blue: 0.16))
                                    .cornerRadius(12)
                                    .offset(x: xPosition, y: 20)
                            }
                            
                            // Day letter
                            Text(weekDays[index])
                                .font(Font.custom("Inter", size: 15))
                                .tracking(0.30)
                                .lineSpacing(20)
                                .foregroundColor(isSelected ? .white : Color(red: 0.49, green: 0.52, blue: 0.55))
                                .offset(x: xPosition, y: 4)
                            
                            // Day number (tappable)
                            Button(action: {
                                selectedDate = date
                            }) {
                                Text("\(day)")
                                    .font(Font.custom("Inter", size: 16).weight(.bold))
                                    .tracking(0.30)
                                    .lineSpacing(20)
                                    .foregroundColor(isSelected ? .white : Color(red: 0.11, green: 0.12, blue: 0.16))
                            }
                            .offset(x: xPosition, y: 36)
                        }
                    }
                    .frame(height: 148)
                    .padding(.horizontal, 20)
                    
                    // My Analysis Section
                    VStack(alignment: .leading, spacing: 20) {
                        HStack {
                            Text("My Analysis")
                                .font(.custom("Inter", size: 20))
                                .fontWeight(.semibold)
                                .foregroundColor(.textColor)
                            
                            Spacer()
                            
                            Button(action: {
                                // View all action
                            }) {
                                Text("View all")
                                    .font(.custom("Inter", size: 14))
                                    .foregroundColor(.actionColor)
                            }
                        }
                        
                        // Photos list
                        if let photos = viewModel.photosForDate(selectedDate), !photos.isEmpty {
                            VStack(alignment: .leading, spacing: 16) {
                                // Individual cards without container
                                ForEach(photos.prefix(showAllPhotos ? photos.count : 3)) { photo in
                                    NavigationLink(destination: CalendarDayDetailView(photo: photo)) {
                                        ScheduleCard(photo: photo)
                                    }
                                    .buttonStyle(.plain)
                                }
                                
                                // "View More" button if there are more than 3 photos
                                if photos.count > 3 {
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showAllPhotos.toggle()
                                        }
                                    }) {
                                        HStack {
                                            Text(showAllPhotos ? "Show Less" : "View \(photos.count - 3) More")
                                                .font(.custom("Inter", size: 16))
                                                .fontWeight(.semibold)
                                                .foregroundColor(.actionColor)
                                            
                                            Image(systemName: showAllPhotos ? "chevron.up" : "arrow.right")
                                                .foregroundColor(.actionColor)
                                        }
                                        .frame(maxWidth: .infinity)
                                        .padding()
                                        .background(Color.actionColor.opacity(0.1))
                                        .cornerRadius(12)
                                    }
                                }
                            }
                        } else {
                            // Empty state
                            VStack(spacing: 20) {
                                ZStack {
                                    Circle()
                                        .fill(Color.actionColor.opacity(0.1))
                                        .frame(width: 120, height: 120)
                                    
                                    Image(systemName: "photo.on.rectangle.angled")
                                        .font(.system(size: 50))
                                        .foregroundColor(.actionColor)
                                }
                                
                                VStack(spacing: 8) {
                                    Text("No Memories Yet")
                                        .font(.custom("Montserrat-Black", size: 20))
                                        .foregroundColor(.textColor)
                                    
                                    Text("Capture a photo on this day to see it here")
                                        .font(.custom("Nunito Sans", size: 14))
                                        .foregroundColor(.subTextColor)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 60)
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .padding(.vertical, 8)
            }
            .background(Color.white)
            .sheet(isPresented: $showNotifications) {
                NotificationsView()
                    .presentationDetents([.medium, .large])
                    .presentationDragIndicator(.visible)
            }
        }
    }
    
    // Helper functions
    private func monthYearString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: date)
    }
    
    private func weekDates() -> [Date] {
        let calendar = Calendar.current
        let today = selectedDate
        let weekday = calendar.component(.weekday, from: today)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - 1), to: today)!
        
        return (0..<7).compactMap { day in
            calendar.date(byAdding: .day, value: day, to: startOfWeek)
        }
    }
    
    private func isToday(_ date: Date) -> Bool {
        Calendar.current.isDate(date, inSameDayAs: selectedDate)
    }
}

// Compact Photo Card Component for grid
struct CompactPhotoCard: View {
    let photo: PhotoEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Photo
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 100)
                    .clipped()
            } else {
                Rectangle()
                    .fill(Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50))
                    .frame(height: 100)
            }
            
            // Info overlay
            VStack(alignment: .leading, spacing: 4) {
                Text(photo.locationName ?? "Unknown")
                    .font(.custom("Inter", size: 12))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .lineLimit(1)
                
                if let location = photo.location {
                    Text(location)
                        .font(.custom("Inter", size: 10))
                        .foregroundColor(.white.opacity(0.8))
                        .lineLimit(1)
                }
            }
            .padding(8)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.7), Color.clear]),
                    startPoint: .bottom,
                    endPoint: .top
                )
            )
        }
        .frame(height: 140)
        .background(Color.white)
        .cornerRadius(16)
        .shadow(color: Color(red: 0.71, green: 0.74, blue: 0.79, opacity: 0.12), radius: 16, y: 6)
    }
}

// Schedule Card Component
struct ScheduleCard: View {
    let photo: PhotoEntry
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        return formatter
    }
    
    var body: some View {
        HStack(spacing: 16) {
            // Photo thumbnail - larger
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 16))
            } else {
                RoundedRectangle(cornerRadius: 16)
                    .fill(Color(red: 0.50, green: 0.23, blue: 0.27).opacity(0.50))
                    .frame(width: 100, height: 100)
            }
            
            // Info
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 4) {
                    Image(systemName: "calendar")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.49, green: 0.52, blue: 0.55))
                    Text(dateFormatter.string(from: photo.dateTaken))
                        .font(.custom("Inter", size: 13))
                        .foregroundColor(Color(red: 0.49, green: 0.52, blue: 0.55))
                }
                
                Text(photo.locationName ?? "Unknown Location")
                    .font(.custom("SF Pro", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.textColor)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 12))
                        .foregroundColor(Color(red: 0.49, green: 0.52, blue: 0.55))
                    Text(photo.location ?? "Unknown")
                        .font(.custom("Inter", size: 13))
                        .foregroundColor(Color(red: 0.49, green: 0.52, blue: 0.55))
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(Color(red: 0.49, green: 0.52, blue: 0.55))
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    CalendarView()
}
