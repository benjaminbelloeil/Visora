//
//  CalendarView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct CalendarView: View {
    @StateObject private var viewModel = CalendarViewModel()
    @State private var selectedDate: Date?
    
    var body: some View {
        NavigationStack {
            VStack {
                // Calendar picker
                DatePicker(
                    "Select Date",
                    selection: Binding(
                        get: { selectedDate ?? Date() },
                        set: { selectedDate = $0 }
                    ),
                    displayedComponents: [.date]
                )
                .datePickerStyle(.graphical)
                .padding()
                
                // Photos for selected date
                if let date = selectedDate {
                    if let photos = viewModel.photosForDate(date), !photos.isEmpty {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 10) {
                                ForEach(photos) { photo in
                                    NavigationLink(destination: CalendarDayDetailView(date: date, photos: photos)) {
                                        PhotoCard(photo: photo)
                                    }
                                }
                            }
                            .padding()
                        }
                    } else {
                        VStack(spacing: 16) {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.system(size: 60))
                                .foregroundColor(.gray)
                            Text("No photos for this date")
                                .foregroundColor(.secondary)
                        }
                        .frame(maxHeight: .infinity)
                    }
                } else {
                    VStack(spacing: 16) {
                        Image(systemName: "calendar")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        Text("Select a date to view photos")
                            .foregroundColor(.secondary)
                    }
                    .frame(maxHeight: .infinity)
                }
            }
            .navigationTitle("Calendar")
            .onAppear {
                viewModel.loadPhotos()
            }
        }
    }
}

#Preview {
    CalendarView()
}
