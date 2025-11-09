//
//  PlaceDetailView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import MapKit
import CoreLocation

struct PlaceDetailView: View {
    let place: Place
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // Map preview
                Map(initialPosition: MapCameraPosition.region(MKCoordinateRegion(
                    center: place.coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                ))) {
                    Annotation(place.name, coordinate: place.coordinate) {
                        PlaceAnnotation(place: place)
                    }
                }
                .frame(height: 250)
                .cornerRadius(12)
                
                VStack(alignment: .leading, spacing: 16) {
                    // Title
                    Text(place.name)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    // Category
                    if let category = place.category {
                        HStack {
                            Image(systemName: "tag.fill")
                            Text(category)
                        }
                        .foregroundColor(.accentColor)
                    }
                    
                    Divider()
                    
                    // Description
                    if let description = place.description {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("About")
                                .font(.headline)
                            Text(description)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    // Address
                    if let address = place.address {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Address")
                                .font(.headline)
                            HStack {
                                Image(systemName: "mappin.and.ellipse")
                                Text(address)
                            }
                            .foregroundColor(.secondary)
                        }
                    }
                    
                    // Directions button
                    PrimaryButton(title: "Get Directions") {
                        openInMaps()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func openInMaps() {
        let placemark = MKPlacemark(coordinate: place.coordinate)
        let mapItem = MKMapItem(placemark: placemark)
        mapItem.name = place.name
        mapItem.openInMaps(launchOptions: nil)
    }
}

#Preview {
    NavigationStack {
        PlaceDetailView(
            place: Place(
                id: "1",
                name: "Eiffel Tower",
                coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
                category: "Landmark",
                description: "The iconic iron lattice tower in Paris.",
                address: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France"
            )
        )
    }
}
