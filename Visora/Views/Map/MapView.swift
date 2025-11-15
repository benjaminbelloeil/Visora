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
    @State private var selectedPhoto: PhotoEntry?
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $viewModel.cameraPosition) {
                    UserAnnotation()
                    
                    ForEach(viewModel.photoPins) { photo in
                        if let coordinate = photo.coordinate {
                            Annotation(photo.locationName ?? "Unknown", coordinate: coordinate) {
                                Button(action: {
                                    selectedPhoto = photo
                                }) {
                                    PhotoPinAnnotation(photo: photo)
                                }
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                }
                
                // Photo detail card
                if let photo = selectedPhoto {
                    VStack {
                        Spacer()
                        PhotoMapDetailCard(photo: photo, selectedPhoto: $selectedPhoto)
                            .padding()
                            .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationTitle("My Memories")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.requestLocationPermission()
                viewModel.loadPhotoPins()
            }
        }
    }
}

// Custom Photo Pin Annotation
struct PhotoPinAnnotation: View {
    let photo: PhotoEntry
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                // Pin background
                Circle()
                    .fill(Color.actionColor)
                    .frame(width: 44, height: 44)
                    .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                
                // Photo thumbnail or camera icon
                if let image = photo.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 36, height: 36)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "camera.fill")
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                }
            }
            
            // Pin pointer
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 12))
                .foregroundColor(.actionColor)
                .offset(y: -4)
        }
    }
}

// Photo Detail Card on Map
struct PhotoMapDetailCard: View {
    let photo: PhotoEntry
    @Binding var selectedPhoto: PhotoEntry?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(photo.locationName ?? "Unknown Location")
                        .font(.headline)
                        .foregroundColor(.textColor)
                    
                    if let location = photo.location {
                        HStack(spacing: 4) {
                            Image(systemName: "mappin.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(.actionColor)
                            Text(location)
                                .font(.caption)
                                .foregroundColor(.subTextColor)
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    selectedPhoto = nil
                } label: {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 24))
                        .foregroundColor(.gray.opacity(0.6))
                }
            }
            
            // Photo thumbnail
            if let image = photo.image {
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            
            if let caption = photo.caption {
                Text(caption)
                    .font(.subheadline)
                    .foregroundColor(.subTextColor)
                    .lineLimit(2)
            }
            
            NavigationLink(destination: CalendarDayDetailView(photo: photo)) {
                HStack {
                    Text("View Details")
                        .font(.subheadline)
                        .fontWeight(.semibold)
                    Image(systemName: "arrow.right")
                }
                .foregroundColor(.actionColor)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
    }
}

#Preview {
    MapView()
}
