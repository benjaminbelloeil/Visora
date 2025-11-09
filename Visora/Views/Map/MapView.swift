//
//  MapView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import MapKit

struct MapView: View {
    @StateObject private var viewModel = MapViewModel()
    @State private var selectedPlace: Place?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $viewModel.cameraPosition, selection: $selectedPlace) {
                    UserAnnotation()
                    
                    ForEach(viewModel.nearbyPlaces) { place in
                        Annotation(place.name, coordinate: place.coordinate) {
                            PlaceAnnotation(place: place)
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
                // Place detail card
                if let place = selectedPlace {
                    VStack {
                        Spacer()
                        PlaceDetailCard(place: place, selectedPlace: $selectedPlace)
                            .padding()
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationTitle("Nearby")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.requestLocationPermission()
                viewModel.loadNearbyPlaces()
            }
        }
    }
}

struct PlaceDetailCard: View {
    let place: Place
    @Binding var selectedPlace: Place?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(place.name)
                        .font(.headline)
                    
                    if let category = place.category {
                        Text(category)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                Button {
                    selectedPlace = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            
            if let description = place.description {
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(3)
            }
            
            NavigationLink(destination: PlaceDetailView(place: place)) {
                Text("View Details")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                    .foregroundColor(.accentColor)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(16)
        .shadow(radius: 10)
    }
}

#Preview {
    MapView()
}
