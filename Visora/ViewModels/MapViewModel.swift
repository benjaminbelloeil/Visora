//
//  MapViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import MapKit
import CoreLocation
import Combine
import SwiftUI

@MainActor
class MapViewModel: NSObject, ObservableObject {
    @Published var photoPins: [PhotoEntry] = []
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var isLoading = false
    
    private let locationManager = CLLocationManager()
    private var cancellables = Set<AnyCancellable>()
    private var hasSetInitialPosition = false
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        
        // Listen to calendar updates
        CalendarViewModel.shared.$photosByDate
            .sink { [weak self] _ in
                self?.loadPhotoPins()
            }
            .store(in: &cancellables)
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func loadPhotoPins() {
        isLoading = true
        
        // Get all photos from calendar that have GPS coordinates
        let allPhotos = CalendarViewModel.shared.photosByDate.values.flatMap { $0 }
        photoPins = allPhotos.filter { $0.coordinate != nil }
        
        // Only set initial position once
        if !hasSetInitialPosition {
            setInitialCameraPosition()
            hasSetInitialPosition = true
        }
        
        isLoading = false
    }
    
    private func setInitialCameraPosition() {
        // Center map on first photo or show a nice world view
        if let firstPhoto = photoPins.first, let coordinate = firstPhoto.coordinate {
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
            )
            cameraPosition = .region(region)
        } else if !photoPins.isEmpty {
            // Calculate the center of all pins
            let coordinates = photoPins.compactMap { $0.coordinate }
            let center = calculateCenterCoordinate(coordinates: coordinates)
            let region = MKCoordinateRegion(
                center: center,
                span: MKCoordinateSpan(latitudeDelta: 20, longitudeDelta: 20)
            )
            cameraPosition = .region(region)
        } else {
            // Default to world view if no photos
            let region = MKCoordinateRegion(
                center: CLLocationCoordinate2D(latitude: 20, longitude: 0),
                span: MKCoordinateSpan(latitudeDelta: 60, longitudeDelta: 60)
            )
            cameraPosition = .region(region)
        }
    }
    
    private func calculateCenterCoordinate(coordinates: [CLLocationCoordinate2D]) -> CLLocationCoordinate2D {
        guard !coordinates.isEmpty else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
        
        var minLat = coordinates[0].latitude
        var maxLat = coordinates[0].latitude
        var minLon = coordinates[0].longitude
        var maxLon = coordinates[0].longitude
        
        for coordinate in coordinates {
            minLat = min(minLat, coordinate.latitude)
            maxLat = max(maxLat, coordinate.latitude)
            minLon = min(minLon, coordinate.longitude)
            maxLon = max(maxLon, coordinate.longitude)
        }
        
        return CLLocationCoordinate2D(
            latitude: (minLat + maxLat) / 2,
            longitude: (minLon + maxLon) / 2
        )
    }
    
    func centerOnUserLocation() {
        if let location = locationManager.location {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            cameraPosition = MapCameraPosition.region(region)
        }
    }
    
    func getCurrentLocation() -> CLLocationCoordinate2D? {
        return locationManager.location?.coordinate
    }
    
    func allPinsAtSameLocation() -> Bool {
        guard photoPins.count > 1 else { return false }
        
        // Get first pin's coordinates
        guard let firstCoord = photoPins.first?.coordinate else { return false }
        
        // Check if all other pins are at the same location (within 0.001 degrees, ~100m)
        let tolerance = 0.001
        return photoPins.allSatisfy { photo in
            guard let coord = photo.coordinate else { return false }
            let latDiff = abs(coord.latitude - firstCoord.latitude)
            let lonDiff = abs(coord.longitude - firstCoord.longitude)
            return latDiff < tolerance && lonDiff < tolerance
        }
    }
}

// MARK: - CLLocationManagerDelegate
extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Load photos but don't force camera position after initial load
        if !hasSetInitialPosition {
            loadPhotoPins()
        }
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            // Load photos anyway
            loadPhotoPins()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
