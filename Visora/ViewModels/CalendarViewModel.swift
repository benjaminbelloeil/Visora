//
//  CalendarViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import Combine
import UIKit

@MainActor
class CalendarViewModel: ObservableObject {
    @Published var photosByDate: [Date: [PhotoEntry]] = [:]
    @Published var isLoading = false
    
    // Singleton instance to share across views
    static let shared = CalendarViewModel()
    
    private let photosDirectory: URL
    private let userDefaultsKey = "SavedPhotoEntries"
    
    private init() {
        // Create directory for storing photos
        let documentsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        photosDirectory = documentsPath.appendingPathComponent("VisoraPhotos", isDirectory: true)
        
        // Create directory if it doesn't exist
        if !FileManager.default.fileExists(atPath: photosDirectory.path) {
            try? FileManager.default.createDirectory(at: photosDirectory, withIntermediateDirectories: true)
        }
        
        loadPhotos()
    }
    
    func loadPhotos() {
        isLoading = true
        
        // Load saved photo metadata from UserDefaults
        if let data = UserDefaults.standard.data(forKey: userDefaultsKey),
           let savedPhotos = try? JSONDecoder().decode([PhotoEntry].self, from: data) {
            
            // Load images from file system and organize by date
            for var photo in savedPhotos {
                let imageURL = photosDirectory.appendingPathComponent(photo.imageName)
                if let imageData = try? Data(contentsOf: imageURL),
                   let image = UIImage(data: imageData) {
                    photo.image = image
                    
                    let calendar = Calendar.current
                    let startOfDay = calendar.startOfDay(for: photo.dateTaken)
                    
                    if photosByDate[startOfDay] != nil {
                        photosByDate[startOfDay]?.append(photo)
                    } else {
                        photosByDate[startOfDay] = [photo]
                    }
                }
            }
            
            print("✅ Loaded \(savedPhotos.count) photos from storage")
        }
        
        isLoading = false
    }
    
    func savePhoto(_ photo: PhotoEntry) {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: photo.dateTaken)
        
        // Add to in-memory dictionary
        if photosByDate[startOfDay] != nil {
            photosByDate[startOfDay]?.append(photo)
        } else {
            photosByDate[startOfDay] = [photo]
        }
        
        // Save image to file system
        if let image = photo.image,
           let imageData = image.jpegData(compressionQuality: 0.8) {
            let imageURL = photosDirectory.appendingPathComponent(photo.imageName)
            try? imageData.write(to: imageURL)
        }
        
        // Save metadata to UserDefaults
        persistPhotos()
        
        print("📅 Photo saved to calendar and persisted for date: \(startOfDay)")
    }
    
    private func persistPhotos() {
        // Flatten all photos from dictionary
        let allPhotos = photosByDate.values.flatMap { $0 }
        
        // Encode and save to UserDefaults
        if let encoded = try? JSONEncoder().encode(allPhotos) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            print("💾 Persisted \(allPhotos.count) photos to UserDefaults")
        }
    }
    
    func photosForDate(_ date: Date) -> [PhotoEntry]? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return photosByDate[startOfDay]
    }
    
    func datesWithPhotos() -> Set<Date> {
        Set(photosByDate.keys)
    }
    
    func deletePhoto(_ photo: PhotoEntry) {
        // Remove from dictionary
        for (date, photos) in photosByDate {
            if let index = photos.firstIndex(where: { $0.id == photo.id }) {
                photosByDate[date]?.remove(at: index)
                if photosByDate[date]?.isEmpty == true {
                    photosByDate.removeValue(forKey: date)
                }
                break
            }
        }
        
        // Delete image file
        let imageURL = photosDirectory.appendingPathComponent(photo.imageName)
        try? FileManager.default.removeItem(at: imageURL)
        
        // Update UserDefaults
        persistPhotos()
        
        print("🗑️ Photo deleted: \(photo.id)")
    }
}

