//
//  CalendarViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import Combine

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var photosByDate: [Date: [PhotoEntry]] = [:]
    @Published var isLoading = false
    
    func loadPhotos() {
        isLoading = true
        
        // Simulate loading photos
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            // Group sample photos by date
            let calendar = Calendar.current
            let today = calendar.startOfDay(for: Date())
            
            self?.photosByDate = [
                today: PhotoEntry.sampleData
            ]
            self?.isLoading = false
        }
        
        // TODO: Replace with actual data persistence
        // Example:
        // Task {
        //     let photos = try await photoService.fetchAllPhotos()
        //     photosByDate = Dictionary(grouping: photos) { photo in
        //         Calendar.current.startOfDay(for: photo.date)
        //     }
        //     isLoading = false
        // }
    }
    
    func photosForDate(_ date: Date) -> [PhotoEntry]? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return photosByDate[startOfDay]
    }
    
    func datesWithPhotos() -> Set<Date> {
        Set(photosByDate.keys)
    }
}
