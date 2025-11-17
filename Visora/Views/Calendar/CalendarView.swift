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
    @State private var currentMonth = Date()
    @State private var showNotifications = false
    @State private var showAllPhotos = false
    @State private var showFullCalendar = false
    @State private var showYearPicker = false
    
    private let weekDays = ["S", "M", "T", "W", "T", "F", "S"]
    private let weekDaysFull = ["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"]
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 8), count: 7)
    
    var body: some View {
        NavigationStack {
            ScrollView(showsIndicators: false) {
                VStack(alignment: .leading, spacing: 32) {
                    // Header with notification - Enhanced Title
                    HStack {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("Calendar")
                                .font(.system(size: 34, weight: .bold))
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
                                .fill(Color.cardBackground)
                                .frame(width: 44, height: 44)
                                .overlay(
                                    ZStack {
                                        Image(systemName: "bell")
                                            .font(.system(size: 20))
                                            .foregroundColor(.textColor)
                                        Circle()
                                            .fill(Color(red: 1.0, green: 0.45, blue: 0.2))
                                            .frame(width: 8, height: 8)
                                            .offset(x: 9, y: -10)
                                    }
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    // Compact Week View (Default)
                    if !showFullCalendar {
                        VStack(spacing: 12) {
                            ZStack {
                                // Background card
                                Rectangle()
                                    .foregroundColor(.clear)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 148)
                                    .background(Color.cardSurface)
                                    .cornerRadius(24)
                                    .shadow(
                                        color: Color.black.opacity(0.08),
                                        radius: 12,
                                        x: 0,
                                        y: 4
                                    )
                                
                                // Date title with year picker
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showYearPicker.toggle()
                                    }
                                }) {
                                    HStack(spacing: 4) {
                                        Text(monthYearString(from: selectedDate))
                                            .font(Font.custom("Inter", size: 20).weight(.semibold))
                                            .foregroundColor(.textColor)
                                        
                                        Image(systemName: showYearPicker ? "chevron.up" : "chevron.down")
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.actionColor)
                                    }
                                }
                                .offset(x: -76.6, y: -44)
                                
                                // Navigation arrows
                                HStack(spacing: 16) {
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: -1, to: selectedDate) ?? selectedDate
                                            currentMonth = selectedDate
                                        }
                                    }) {
                                        Image(systemName: "chevron.left")
                                            .foregroundColor(.actionColor)
                                            .frame(width: 24, height: 24)
                                    }
                                    
                                    Button(action: {
                                        withAnimation(.easeInOut(duration: 0.3)) {
                                            selectedDate = Calendar.current.date(byAdding: .weekOfYear, value: 1, to: selectedDate) ?? selectedDate
                                            currentMonth = selectedDate
                                        }
                                    }) {
                                        Image(systemName: "chevron.right")
                                            .foregroundColor(.actionColor)
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .offset(x: 84.6, y: -44)
                                
                                // Expand button
                                Button(action: {
                                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                        showFullCalendar = true
                                        currentMonth = selectedDate
                                        showYearPicker = false
                                    }
                                }) {
                                    Image(systemName: "arrow.up.left.and.arrow.down.right")
                                        .foregroundColor(.actionColor)
                                        .frame(width: 24, height: 24)
                                }
                                .offset(x: 145, y: -44)
                                
                                // Week days and dates
                                let dates = weekDates()
                                ForEach(Array(dates.enumerated()), id: \.offset) { index, date in
                                    let xPosition = -141 + Double(index) * 47
                                    let day = Calendar.current.component(.day, from: date)
                                    let isSelected = Calendar.current.isDate(date, inSameDayAs: selectedDate)
                                    let hasPhotos = viewModel.hasPhotos(for: date)
                                    
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
                                        .foregroundColor(isSelected ? .white : .subTextColor)
                                        .offset(x: xPosition, y: 4)
                                    
                                    // Day number (tappable)
                                    Button(action: {
                                        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                            selectedDate = date
                                        }
                                    }) {
                                        VStack(spacing: 4) {
                                            Text("\(day)")
                                                .font(Font.custom("Inter", size: 16).weight(.bold))
                                                .tracking(0.30)
                                                .lineSpacing(20)
                                                .foregroundColor(isSelected ? .white : .textColor)
                                            
                                            // Orange dot for photos
                                            if hasPhotos {
                                                Circle()
                                                    .fill(isSelected ? Color.white : Color.actionColor)
                                                    .frame(width: 5, height: 5)
                                            }
                                        }
                                    }
                                    .offset(x: xPosition, y: 36)
                                }
                            }
                            .frame(height: 148)
                            
                            // Year Picker for Compact View
                            if showYearPicker {
                                ZStack {
                                    // Scrollable year buttons
                                    ScrollView(.horizontal, showsIndicators: false) {
                                        HStack(spacing: 12) {
                                            ForEach(yearRange(), id: \.self) { year in
                                                Button(action: {
                                                    withAnimation(.easeInOut(duration: 0.3)) {
                                                        let calendar = Calendar.current
                                                        var components = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                                                        components.year = year
                                                        if let newDate = calendar.date(from: components) {
                                                            selectedDate = newDate
                                                            currentMonth = newDate
                                                        }
                                                        showYearPicker = false
                                                    }
                                                }) {
                                                    Text(String(year))
                                                        .font(.system(size: 16, weight: currentYearForDate(selectedDate) == year ? .bold : .regular))
                                                        .foregroundColor(currentYearForDate(selectedDate) == year ? .white : .textColor)
                                                        .padding(.horizontal, 20)
                                                        .padding(.vertical, 10)
                                                        .background(
                                                            RoundedRectangle(cornerRadius: 12)
                                                                .fill(currentYearForDate(selectedDate) == year ? Color.actionColor : Color.cardBackground)
                                                        )
                                                }
                                            }
                                        }
                                        .padding(.horizontal, 4)
                                    }
                                    .frame(height: 50)

                                    // Left and right blur fade overlays
                                    HStack(spacing: 0) {
                                        // Left fade
                                        LinearGradient(
                                            colors: [
                                                Color.appBackground.opacity(0.9),
                                                Color.appBackground.opacity(0.5),
                                                Color.appBackground.opacity(0.0)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .frame(width: 40)
                                        .allowsHitTesting(false)

                                        Spacer()

                                        // Right fade
                                        LinearGradient(
                                            colors: [
                                                Color.appBackground.opacity(0.0),
                                                Color.appBackground.opacity(0.5),
                                                Color.appBackground.opacity(0.9)
                                            ],
                                            startPoint: .leading,
                                            endPoint: .trailing
                                        )
                                        .frame(width: 40)
                                        .allowsHitTesting(false)
                                    }
                                }
                                .padding(.horizontal, 8)
                                .padding(.top, 12)
                            }
                        }
                        .padding(.horizontal, 20)
                    }
                    
                    // Full Month Calendar View (Expandable)
                    if showFullCalendar {
                        VStack(spacing: 12) {
                            // Calendar Grid Card
                            VStack(spacing: 16) {
                                // Header: Month/Year on left, arrows on right, collapse button
                                HStack(spacing: 0) {
                                    // Month/Year (tappable)
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showYearPicker.toggle()
                                        }
                                    }) {
                                        HStack(spacing: 4) {
                                            Text(monthYearString(from: currentMonth))
                                                .font(Font.custom("Inter", size: 20).weight(.semibold))
                                                .foregroundColor(.textColor)
                                            
                                            Image(systemName: showYearPicker ? "chevron.up" : "chevron.down")
                                                .font(.system(size: 12, weight: .semibold))
                                                .foregroundColor(.actionColor)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    // Navigation arrows
                                    HStack(spacing: 16) {
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                currentMonth = Calendar.current.date(byAdding: .month, value: -1, to: currentMonth) ?? currentMonth
                                            }
                                        }) {
                                            Image(systemName: "chevron.left")
                                                .foregroundColor(.actionColor)
                                                .frame(width: 24, height: 24)
                                        }
                                        
                                        Button(action: {
                                            withAnimation(.easeInOut(duration: 0.3)) {
                                                currentMonth = Calendar.current.date(byAdding: .month, value: 1, to: currentMonth) ?? currentMonth
                                            }
                                        }) {
                                            Image(systemName: "chevron.right")
                                                .foregroundColor(.actionColor)
                                                .frame(width: 24, height: 24)
                                        }
                                    }
                                    
                                    Spacer()
                                        .frame(width: 16)
                                    
                                    // Collapse button
                                    Button(action: {
                                        withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                                            showFullCalendar = false
                                            showYearPicker = false
                                        }
                                    }) {
                                        Image(systemName: "arrow.down.right.and.arrow.up.left")
                                            .foregroundColor(.actionColor)
                                            .frame(width: 24, height: 24)
                                    }
                                }
                                .frame(height: 44)
                                .offset(y: -12)
                                
                                // Year Picker (Expandable)
                                if showYearPicker {
                                    VStack(spacing: 0) {
                                        ScrollView(.horizontal, showsIndicators: false) {
                                            HStack(spacing: 12) {
                                                ForEach(yearRange(), id: \.self) { year in
                                                    Button(action: {
                                                        withAnimation(.easeInOut(duration: 0.3)) {
                                                            let calendar = Calendar.current
                                                            var components = calendar.dateComponents([.year, .month, .day], from: currentMonth)
                                                            components.year = year
                                                            if let newDate = calendar.date(from: components) {
                                                                currentMonth = newDate
                                                                // Update selectedDate to match the new month/year
                                                                var selectedComponents = calendar.dateComponents([.year, .month, .day], from: selectedDate)
                                                                selectedComponents.year = year
                                                                selectedComponents.month = components.month
                                                                if let newSelectedDate = calendar.date(from: selectedComponents) {
                                                                    selectedDate = newSelectedDate
                                                                }
                                                            }
                                                            showYearPicker = false
                                                        }
                                                    }) {
                                                        Text(String(year))
                                                            .font(.system(size: 16, weight: currentYear() == year ? .bold : .regular))
                                                            .foregroundColor(currentYear() == year ? .white : .textColor)
                                                            .padding(.horizontal, 20)
                                                            .padding(.vertical, 10)
                                                            .background(
                                                                RoundedRectangle(cornerRadius: 12)
                                                                    .fill(currentYear() == year ? Color.actionColor : Color.cardBackground)
                                                            )
                                                    }
                                                }
                                            }
                                            .padding(.horizontal, 4)
                                        }
                                        .frame(height: 50)
                                        
                                        Divider()
                                            .padding(.top, 12)
                                    }
                                }
                                
                                // Week day headers
                                HStack(spacing: 0) {
                                    ForEach(weekDaysFull, id: \.self) { day in
                                        Text(day)
                                            .font(.system(size: 12, weight: .semibold))
                                            .foregroundColor(.subTextColor)
                                            .frame(maxWidth: .infinity)
                                    }
                                }
                                .padding(.bottom, 8)
                                
                                // Calendar days grid
                                LazyVGrid(columns: columns, spacing: 12) {
                                    ForEach(daysInMonth(), id: \.self) { date in
                                        if let date = date {
                                            CalendarDayCell(
                                                date: date,
                                                isSelected: Calendar.current.isDate(date, inSameDayAs: selectedDate),
                                                isToday: Calendar.current.isDateInToday(date),
                                                hasPhotos: viewModel.hasPhotos(for: date)
                                            )
                                            .onTapGesture {
                                                withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                                                    selectedDate = date
                                                }
                                            }
                                        } else {
                                            // Empty cell for days not in current month
                                            Color.clear
                                                .frame(height: 50)
                                        }
                                    }
                                }
                            }
                            .padding(20)
                            .background(Color.cardSurface)
                            .cornerRadius(24)
                            .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
                        }
                        .padding(.horizontal, 20)
                    }
                    
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
            .background(Color.appBackground)
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
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: date)
    }
    
    private func currentYear() -> Int {
        return Calendar.current.component(.year, from: currentMonth)
    }
    
    private func currentYearForDate(_ date: Date) -> Int {
        return Calendar.current.component(.year, from: date)
    }
    
    private func yearRange() -> [Int] {
        let currentYear = Calendar.current.component(.year, from: Date())
        // Show years from 10 years ago to current year
        return Array((currentYear - 10)...currentYear).reversed()
    }
    
    private func daysInMonth() -> [Date?] {
        let calendar = Calendar.current
        let interval = calendar.dateInterval(of: .month, for: currentMonth)!
        let firstWeekday = calendar.component(.weekday, from: interval.start)
        let daysInMonth = calendar.range(of: .day, in: .month, for: currentMonth)!.count
        
        var days: [Date?] = []
        
        // Add empty cells for days before the first day of the month
        for _ in 1..<firstWeekday {
            days.append(nil)
        }
        
        // Add all days of the month
        for day in 1...daysInMonth {
            if let date = calendar.date(bySetting: .day, value: day, of: currentMonth) {
                days.append(date)
            }
        }
        
        return days
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

// Calendar Day Cell Component
struct CalendarDayCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasPhotos: Bool
    
    private var day: Int {
        Calendar.current.component(.day, from: date)
    }
    
    var body: some View {
        VStack(spacing: 6) {
            Text("\(day)")
                .font(.system(size: 16, weight: isSelected ? .bold : .regular))
                .foregroundColor(isSelected ? .white : (isToday ? .actionColor : .textColor))
                .frame(width: 40, height: 40)
                .background(
                    Group {
                        if isSelected {
                            Circle()
                                .fill(Color.actionColor)
                        } else if isToday {
                            Circle()
                                .stroke(Color.actionColor, lineWidth: 2)
                        }
                    }
                )
            
            // Orange dot indicator for photos
            if hasPhotos {
                Circle()
                    .fill(isSelected ? Color.white : Color.actionColor)
                    .frame(width: 6, height: 6)
            } else {
                // Spacer to maintain consistent height
                Circle()
                    .fill(Color.clear)
                    .frame(width: 6, height: 6)
            }
        }
        .frame(height: 50)
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
        .background(Color.cardSurface)
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
                        .foregroundColor(.subTextColor)
                    Text(dateFormatter.string(from: photo.dateTaken))
                        .font(.custom("Inter", size: 13))
                        .foregroundColor(.subTextColor)
                }
                
                Text(photo.locationName ?? "Unknown Location")
                    .font(.custom("SF Pro", size: 17))
                    .fontWeight(.semibold)
                    .foregroundColor(.textColor)
                    .lineLimit(2)
                
                HStack(spacing: 4) {
                    Image(systemName: "mappin.circle")
                        .font(.system(size: 12))
                        .foregroundColor(.subTextColor)
                    Text(photo.location ?? "Unknown")
                        .font(.custom("Inter", size: 13))
                        .foregroundColor(.subTextColor)
                        .lineLimit(1)
                }
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.subTextColor)
        }
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(Color.cardSurface)
        .cornerRadius(20)
        .shadow(color: Color.black.opacity(0.08), radius: 12, x: 0, y: 4)
    }
}

#Preview {
    CalendarView()
}
