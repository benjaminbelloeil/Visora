//
//  CalendarViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import Combine
import UIKit
import CoreLocation

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
    }
    
    private func persistPhotos() {
        // Flatten all photos from dictionary
        let allPhotos = photosByDate.values.flatMap { $0 }
        
        // Encode and save to UserDefaults
        if let encoded = try? JSONEncoder().encode(allPhotos) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }
    
    func photosForDate(_ date: Date) -> [PhotoEntry]? {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        return photosByDate[startOfDay]
    }
    
    // Add GPS coordinates to photos that don't have them (using current location)
    func addGPSToPhotosWithoutLocation(currentLocation: CLLocationCoordinate2D) async {
        var updatedPhotos: [PhotoEntry] = []
        var updateCount = 0
        
        for (_, photos) in photosByDate {
            for photo in photos {
                if photo.latitude == nil || photo.longitude == nil {
                    // Reverse geocode to get location name
                    let geocoder = CLGeocoder()
                    let location = CLLocation(latitude: currentLocation.latitude, longitude: currentLocation.longitude)
                    
                    var locationString = photo.location
                    if let placemarks = try? await geocoder.reverseGeocodeLocation(location),
                       let placemark = placemarks.first {
                        var locationParts: [String] = []
                        if let locality = placemark.locality {
                            locationParts.append(locality)
                        }
                        if let country = placemark.country {
                            locationParts.append(country)
                        }
                        locationString = locationParts.joined(separator: ", ")
                    }
                    
                    // Create new PhotoEntry with GPS coordinates
                    let updatedPhoto = PhotoEntry(
                        id: photo.id,
                        image: photo.image,
                        imageName: photo.imageName,
                        dateTaken: photo.dateTaken,
                        location: locationString,
                        caption: photo.caption,
                        locationName: photo.locationName,
                        aiDescription: photo.aiDescription,
                        fact1: photo.fact1,
                        fact2: photo.fact2,
                        fact3: photo.fact3,
                        latitude: currentLocation.latitude,
                        longitude: currentLocation.longitude
                    )
                    
                    updateCount += 1
                    updatedPhotos.append(updatedPhoto)
                } else {
                    // Photo already has GPS, keep as is
                    updatedPhotos.append(photo)
                }
            }
        }
        
        if updateCount > 0 {
            // Rebuild the dictionary with updated photos
            photosByDate.removeAll()
            for photo in updatedPhotos {
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: photo.dateTaken)
                
                if photosByDate[startOfDay] != nil {
                    photosByDate[startOfDay]?.append(photo)
                } else {
                    photosByDate[startOfDay] = [photo]
                }
            }
            
            // Save the updated photos
            persistPhotos()
        }
    }
    
    // Extract GPS from original photo files and restore correct locations
    func restoreGPSFromImages() async {
        var updatedPhotos: [PhotoEntry] = []
        var updateCount = 0
        
        for (_, photos) in photosByDate {
            for photo in photos {
                // Try to get GPS from geocoding the location name or location string
                if let locationName = photo.locationName, !locationName.isEmpty {
                    
                    // Try geocoding the location name
                    let geocoder = CLGeocoder()
                    
                    // Try the location name first, then fallback to location string
                    let addressToGeocode = locationName
                    if let placemarks = try? await geocoder.geocodeAddressString(addressToGeocode),
                       let placemark = placemarks.first,
                       let location = placemark.location {
                        
                        var locationString = photo.location
                        var locationParts: [String] = []
                        if let locality = placemark.locality {
                            locationParts.append(locality)
                        }
                        if let country = placemark.country {
                            locationParts.append(country)
                        }
                        locationString = locationParts.joined(separator: ", ")
                        
                        let updatedPhoto = PhotoEntry(
                            id: photo.id,
                            image: photo.image,
                            imageName: photo.imageName,
                            dateTaken: photo.dateTaken,
                            location: locationString,
                            caption: photo.caption,
                            locationName: photo.locationName,
                            aiDescription: photo.aiDescription,
                            fact1: photo.fact1,
                            fact2: photo.fact2,
                            fact3: photo.fact3,
                            latitude: location.coordinate.latitude,
                            longitude: location.coordinate.longitude
                        )
                        
                        updateCount += 1
                        updatedPhotos.append(updatedPhoto)
                        continue
                    }
                    
                    // If landmark name didn't work, try the AI's location string (e.g., "Florence, Italy")
                    if let locationStr = photo.location, !locationStr.isEmpty {
                        if let placemarks = try? await geocoder.geocodeAddressString(locationStr),
                           let placemark = placemarks.first,
                           let location = placemark.location {
                            
                            let updatedPhoto = PhotoEntry(
                                id: photo.id,
                                image: photo.image,
                                imageName: photo.imageName,
                                dateTaken: photo.dateTaken,
                                location: locationStr,
                                caption: photo.caption,
                                locationName: photo.locationName,
                                aiDescription: photo.aiDescription,
                                fact1: photo.fact1,
                                fact2: photo.fact2,
                                fact3: photo.fact3,
                                latitude: location.coordinate.latitude,
                                longitude: location.coordinate.longitude
                            )
                            
                            updateCount += 1
                            updatedPhotos.append(updatedPhoto)
                            continue
                        }
                    }
                }
                
                // No GPS data found, keep as is
                updatedPhotos.append(photo)
            }
        }
        
        if updateCount > 0 {
            // Rebuild the dictionary with updated photos
            photosByDate.removeAll()
            for photo in updatedPhotos {
                let calendar = Calendar.current
                let startOfDay = calendar.startOfDay(for: photo.dateTaken)
                
                if photosByDate[startOfDay] != nil {
                    photosByDate[startOfDay]?.append(photo)
                } else {
                    photosByDate[startOfDay] = [photo]
                }
            }
            
            // Save the updated photos
            persistPhotos()
        }
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
    }
    
    func toggleFavorite(for photo: PhotoEntry) {
        // Find and update the photo
        for (date, photos) in photosByDate {
            if let index = photos.firstIndex(where: { $0.id == photo.id }) {
                var updatedPhoto = photos[index]
                updatedPhoto.isFavorite.toggle()
                photosByDate[date]?[index] = updatedPhoto
                persistPhotos()
                
                // Provide haptic feedback
                let generator = UIImpactFeedbackGenerator(style: .medium)
                generator.impactOccurred()
                
                return
            }
        }
    }
}

