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
    @State private var selectedPhotoIndex: Int = 0
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                Map(position: $viewModel.cameraPosition, interactionModes: .all) {
                    ForEach(viewModel.photoPins) { photo in
                        if let coordinate = photo.coordinate {
                            Annotation(photo.locationName ?? "Unknown", coordinate: coordinate) {
                                Button(action: {
                                    selectedPhoto = photo
                                    if let index = viewModel.photoPins.firstIndex(where: { $0.id == photo.id }) {
                                        selectedPhotoIndex = index
                                    }
                                }) {
                                    MapPinAnnotation(photo: photo)
                                }
                            }
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                    MapCompass()
                    MapScaleView()
                }
                
                // Photo detail card
                if let photo = selectedPhoto {
                    VStack {
                        Spacer()
                        PhotoMapDetailCard(
                            photo: photo,
                            selectedPhoto: $selectedPhoto,
                            allPhotos: viewModel.photoPins,
                            currentIndex: $selectedPhotoIndex,
                            cameraPosition: $viewModel.cameraPosition
                        )
                        .padding()
                        .transition(.move(edge: .bottom))
                    }
                }
            }
            .navigationTitle("My Memories")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.requestLocationPermission()
                // Small delay to ensure CalendarViewModel has loaded
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    viewModel.loadPhotoPins()
                }
            }
        }
    }
}

// Map Pin Annotation - Simple pin drop style like Home preview
struct MapPinAnnotation: View {
    let photo: PhotoEntry
    
    var body: some View {
        VStack(spacing: 0) {
            // Pin circle with photo thumbnail
            ZStack {
                Circle()
                    .fill(Color.actionColor)
                    .frame(width: 40, height: 40)
                    .shadow(color: .black.opacity(0.3), radius: 4, y: 2)
                
                if let image = photo.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 32, height: 32)
                        .clipShape(Circle())
                } else {
                    Image(systemName: "photo.fill")
                        .font(.system(size: 16))
                        .foregroundColor(.white)
                }
            }
            
            // Pin pointer
            Image(systemName: "arrowtriangle.down.fill")
                .font(.system(size: 10))
                .foregroundColor(.actionColor)
                .offset(y: -4)
        }
    }
}

// Custom Photo Pin Annotation (Old - keeping for reference)
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
    let allPhotos: [PhotoEntry]
    @Binding var currentIndex: Int
    @Binding var cameraPosition: MapCameraPosition
    
    @State private var dragOffset: CGFloat = 0
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Drag indicator
            RoundedRectangle(cornerRadius: 3)
                .fill(Color.gray.opacity(0.3))
                .frame(width: 40, height: 5)
                .frame(maxWidth: .infinity)
                .padding(.top, 8)
            
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
            }
            
            // Photo thumbnail with swipe indicators
            ZStack {
                if let image = photo.image {
                    Image(uiImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(height: 120)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                // Swipe indicators (only show if there are multiple photos)
                if allPhotos.count > 1 {
                    HStack {
                        // Left swipe indicator
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(.leading, 12)
                        
                        Spacer()
                        
                        // Right swipe indicator
                        Image(systemName: "chevron.right")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.white)
                            .padding(8)
                            .background(Color.black.opacity(0.5))
                            .clipShape(Circle())
                            .padding(.trailing, 12)
                    }
                }
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
        .background(Color.cardSurface)
        .cornerRadius(20)
        .shadow(color: .black.opacity(0.1), radius: 10, y: 5)
        .offset(y: dragOffset)
        .gesture(
            DragGesture()
                .onChanged { value in
                    // Only allow dragging down or horizontal
                    if value.translation.height > 0 {
                        dragOffset = value.translation.height
                    } else if abs(value.translation.width) > abs(value.translation.height) {
                        // Allow horizontal swipe to start
                    }
                }
                .onEnded { value in
                    // Swipe down to dismiss
                    if value.translation.height > 100 {
                        withAnimation {
                            selectedPhoto = nil
                        }
                        dragOffset = 0
                    }
                    // Swipe left/right to navigate
                    else if abs(value.translation.width) > 50 && abs(value.translation.height) < 50 {
                        if value.translation.width > 0 {
                            navigateToPrevious()
                        } else {
                            navigateToNext()
                        }
                        dragOffset = 0
                    }
                    // Reset if didn't meet threshold
                    else {
                        withAnimation {
                            dragOffset = 0
                        }
                    }
                }
        )
    }
    
    private func navigateToNext() {
        guard allPhotos.count > 1 else { return }
        let nextIndex = (currentIndex + 1) % allPhotos.count
        withAnimation {
            currentIndex = nextIndex
            selectedPhoto = allPhotos[nextIndex]
            
            // Move camera to new location
            if let coordinate = allPhotos[nextIndex].coordinate {
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                cameraPosition = .region(region)
            }
        }
    }
    
    private func navigateToPrevious() {
        guard allPhotos.count > 1 else { return }
        let previousIndex = (currentIndex - 1 + allPhotos.count) % allPhotos.count
        withAnimation {
            currentIndex = previousIndex
            selectedPhoto = allPhotos[previousIndex]
            
            // Move camera to new location
            if let coordinate = allPhotos[previousIndex].coordinate {
                let region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                )
                cameraPosition = .region(region)
            }
        }
    }
}

#Preview {
    MapView()
}
