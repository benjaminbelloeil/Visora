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
        
        print("🗺️ Loaded \(photoPins.count) photos with GPS coordinates for map")
        
        // Center map on first photo or user location
        if let firstPhoto = photoPins.first, let coordinate = firstPhoto.coordinate {
            let region = MKCoordinateRegion(
                center: coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1)
            )
            cameraPosition = MapCameraPosition.region(region)
        } else if let userLocation = locationManager.location {
            let region = MKCoordinateRegion(
                center: userLocation.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            cameraPosition = MapCameraPosition.region(region)
        }
        
        isLoading = false
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
}

// MARK: - CLLocationManagerDelegate
extension MapViewModel: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else { return }
        
        // Only center on user if no photos yet
        if photoPins.isEmpty {
            let region = MKCoordinateRegion(
                center: location.coordinate,
                span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
            )
            cameraPosition = MapCameraPosition.region(region)
        }
        
        loadPhotoPins()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
            // Load photos anyway
            loadPhotoPins()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
