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
    @Published var nearbyPlaces: [Place] = []
    @Published var cameraPosition: MapCameraPosition = .automatic
    @Published var isLoading = false
    
    private let locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestLocationPermission() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func loadNearbyPlaces() {
        isLoading = true
        
        // Simulate loading nearby places
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.nearbyPlaces = Place.sampleData
            self?.isLoading = false
            
            // Center map on first place if available
            if let firstPlace = self?.nearbyPlaces.first {
                let region = MKCoordinateRegion(
                    center: firstPlace.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                self?.cameraPosition = MapCameraPosition.region(region)
            }
        }
        
        // TODO: Implement actual nearby places search
        // Example:
        // Task {
        //     guard let userLocation = locationManager.location else { return }
        //     do {
        //         nearbyPlaces = try await placesService.searchNearby(
        //             coordinate: userLocation.coordinate,
        //             radius: 5000
        //         )
        //     } catch {
        //         print("Error loading nearby places: \(error)")
        //     }
        //     isLoading = false
        // }
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
        
        let region = MKCoordinateRegion(
            center: location.coordinate,
            span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        )
        cameraPosition = MapCameraPosition.region(region)
        
        loadNearbyPlaces()
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            locationManager.startUpdatingLocation()
        case .denied, .restricted:
            print("Location access denied")
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }
}
