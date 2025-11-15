//
//  PhotoCaptureView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import PhotosUI

struct PhotoCaptureView: View {
    @StateObject private var viewModel = PhotoViewModel()
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var selectedItem: PhotosPickerItem?
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background color matching other tabs
                Color.appBackground
                    .ignoresSafeArea()
                
                if viewModel.isProcessing {
                    // Beautiful AI Analysis Loading Screen
                    VStack(spacing: 30) {
                        ZStack {
                            // Outer rotating ring
                            Circle()
                                .trim(from: 0, to: 0.7)
                                .stroke(
                                    Color.actionColor.opacity(0.3),
                                    style: StrokeStyle(lineWidth: 3, lineCap: .round)
                                )
                                .frame(width: 160, height: 160)
                                .rotationEffect(.degrees(viewModel.isProcessing ? 360 : 0))
                                .animation(.linear(duration: 2).repeatForever(autoreverses: false), value: viewModel.isProcessing)
                            
                            // Pulsing circles
                            Circle()
                                .stroke(Color.actionColor.opacity(0.2), lineWidth: 3)
                                .frame(width: 140, height: 140)
                                .scaleEffect(viewModel.isProcessing ? 1.2 : 1.0)
                                .opacity(viewModel.isProcessing ? 0.5 : 1.0)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.isProcessing)
                            
                            Circle()
                                .stroke(Color.actionColor.opacity(0.3), lineWidth: 3)
                                .frame(width: 110, height: 110)
                                .scaleEffect(viewModel.isProcessing ? 1.0 : 1.2)
                                .opacity(viewModel.isProcessing ? 1.0 : 0.5)
                                .animation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true), value: viewModel.isProcessing)
                            
                            // Sparkles around the brain
                            ForEach(0..<8) { index in
                                Image(systemName: "sparkle")
                                    .font(.system(size: 12))
                                    .foregroundColor(.actionColor.opacity(0.6))
                                    .offset(y: -60)
                                    .rotationEffect(.degrees(Double(index) * 45))
                                    .scaleEffect(viewModel.isProcessing ? 1.0 : 0.5)
                                    .opacity(viewModel.isProcessing ? 1.0 : 0.3)
                                    .animation(
                                        .easeInOut(duration: 1.0)
                                            .repeatForever(autoreverses: true)
                                            .delay(Double(index) * 0.125),
                                        value: viewModel.isProcessing
                                    )
                            }
                            
                            // AI brain icon
                            ZStack {
                                Circle()
                                    .fill(Color.actionColor)
                                    .frame(width: 80, height: 80)
                                    .shadow(color: Color.actionColor.opacity(0.3), radius: 10, x: 0, y: 5)
                                    .scaleEffect(viewModel.isProcessing ? 1.05 : 1.0)
                                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: viewModel.isProcessing)
                                
                                Image(systemName: "brain.head.profile")
                                    .font(.system(size: 35))
                                    .foregroundColor(.white)
                                    .rotationEffect(.degrees(viewModel.isProcessing ? 360 : 0))
                                    .animation(.linear(duration: 3).repeatForever(autoreverses: false), value: viewModel.isProcessing)
                            }
                        }
                        .padding(.top, 50)
                        
                        VStack(spacing: 12) {
                            Text("AI Analysis in Progress")
                                .font(.title2)
                                .fontWeight(.bold)
                                .foregroundColor(.textColor)
                                .opacity(viewModel.isProcessing ? 1.0 : 0.7)
                                .animation(.easeInOut(duration: 0.8).repeatForever(autoreverses: true), value: viewModel.isProcessing)
                            
                            Text("Discovering the story behind your photo...")
                                .font(.body)
                                .foregroundColor(.subTextColor)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal, 40)
                        }
                        
                        // Animated progress indicators
                        HStack(spacing: 12) {
                            ForEach(0..<3) { index in
                                Circle()
                                    .fill(Color.actionColor)
                                    .frame(width: 10, height: 10)
                                    .scaleEffect(viewModel.isProcessing ? 1.2 : 0.5)
                                    .opacity(viewModel.isProcessing ? 1.0 : 0.3)
                                    .animation(
                                        .easeInOut(duration: 0.6)
                                            .repeatForever()
                                            .delay(Double(index) * 0.2),
                                        value: viewModel.isProcessing
                                    )
                            }
                        }
                        .padding(.top, 20)
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .transition(.opacity.combined(with: .scale))
                    
                } else if let photoEntry = viewModel.currentPhoto {
                    PhotoResultView(photoEntry: photoEntry)
                        .environmentObject(viewModel)
                        
                } else {
                    // Main capture screen with enhanced design
                    VStack(spacing: 0) {
                        Spacer()
                        
                        VStack(spacing: 30) {
                            // Hero section with gradient card
                            VStack(spacing: 20) {
                                ZStack {
                                    // Decorative circles
                                    Circle()
                                        .fill(Color.actionColor.opacity(0.15))
                                        .frame(width: 160, height: 160)
                                        .offset(x: -40, y: -20)
                                    
                                    Circle()
                                        .fill(Color.actionColor.opacity(0.08))
                                        .frame(width: 120, height: 120)
                                        .offset(x: 50, y: 15)
                                    
                                    // Camera icon
                                    ZStack {
                                        Circle()
                                            .fill(Color.actionColor)
                                            .frame(width: 100, height: 100)
                                            .shadow(color: Color.actionColor.opacity(0.4), radius: 20, x: 0, y: 10)
                                        
                                        Image(systemName: "camera.fill")
                                            .font(.system(size: 40))
                                            .foregroundColor(.white)
                                    }
                                }
                                .frame(height: 140)
                                
                                Text("Capture Your Adventure")
                                    .font(.system(size: 28, weight: .bold))
                                    .foregroundColor(.textColor)
                                
                                Text("Unlock the stories behind landmarks with AI")
                                    .font(.body)
                                    .multilineTextAlignment(.center)
                                    .foregroundColor(.subTextColor)
                                    .padding(.horizontal, 30)
                            }
                            
                            // Feature cards - more compact
                            VStack(spacing: 12) {
                                CompactFeatureCard(icon: "sparkles", title: "AI Recognition", description: "Powered by Gemini AI")
                                CompactFeatureCard(icon: "info.circle.fill", title: "Rich Details", description: "Historical facts & insights")
                                CompactFeatureCard(icon: "map.fill", title: "Location Info", description: "Precise identification")
                            }
                            .padding(.horizontal, 24)
                            
                            // Action buttons
                            VStack(spacing: 14) {
                                // Take Photo Button
                                Button(action: {
                                    showingCamera = true
                                }) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "camera.fill")
                                            .font(.title3)
                                            .foregroundColor(.white)
                                        Text("Take Photo")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                            .foregroundColor(.white)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(
                                        RoundedRectangle(cornerRadius: 16)
                                            .fill(Color.actionColor)
                                    )
                                    .shadow(color: Color.actionColor.opacity(0.4), radius: 15, x: 0, y: 8)
                                }
                                
                                // Choose from Library Button
                                PhotosPicker(selection: $selectedItem, matching: .images) {
                                    HStack(spacing: 12) {
                                        Image(systemName: "photo.on.rectangle")
                                            .font(.title3)
                                        Text("Choose from Library")
                                            .font(.headline)
                                            .fontWeight(.semibold)
                                    }
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 16)
                                    .background(Color.cardSurface)
                                    .foregroundColor(.actionColor)
                                    .cornerRadius(16)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 16)
                                            .stroke(Color.actionColor.opacity(0.3), lineWidth: 2)
                                    )
                                    .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 5)
                                }
                            }
                            .padding(.horizontal, 24)
                        }
                        
                        Spacer()
                    }
                }
            }
            .fullScreenCover(isPresented: $showingCamera) {
                ImagePicker(sourceType: .camera) { image in
                    Task {
                        await viewModel.processPhoto(image, asset: nil)
                    }
                }
                .ignoresSafeArea()
            }
            .onChange(of: selectedItem) { _, newValue in
                Task {
                    if let newValue = newValue {
                        // Load the image data
                        if let data = try? await newValue.loadTransferable(type: Data.self),
                           let image = UIImage(data: data) {
                            
                            // Try to get the PHAsset for location info
                            var phAsset: PHAsset?
                            if let assetIdentifier = newValue.itemIdentifier {
                                let fetchResult = PHAsset.fetchAssets(withLocalIdentifiers: [assetIdentifier], options: nil)
                                phAsset = fetchResult.firstObject
                            }
                            
                            await viewModel.processPhoto(image, asset: phAsset)
                        }
                    }
                }
            }
        }
    }
}

// Feature Card Component
struct FeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.actionColor.opacity(0.1))
                    .frame(width: 50, height: 50)
                
                Image(systemName: icon)
                    .font(.title3)
                    .foregroundColor(.actionColor)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.textColor)
                
                Text(description)
                    .font(.subheadline)
                    .foregroundColor(.subTextColor)
            }
            
            Spacer()
        }
        .padding(16)
        .background(Color.cardSurface)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 8, x: 0, y: 4)
    }
}

// Compact Feature Card Component (for single page layout)
struct CompactFeatureCard: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(Color.actionColor.opacity(0.1))
                    .frame(width: 40, height: 40)
                
                Image(systemName: icon)
                    .font(.system(size: 16))
                    .foregroundColor(.actionColor)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.textColor)
                
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(.subTextColor)
            }
            
            Spacer()
        }
        .padding(12)
        .background(Color.cardSurface)
        .cornerRadius(10)
        .shadow(color: Color.black.opacity(0.05), radius: 6, x: 0, y: 3)
    }
}

// Simple ImagePicker wrapper for camera
struct ImagePicker: UIViewControllerRepresentable {
    let sourceType: UIImagePickerController.SourceType
    let onImagePicked: (UIImage) -> Void
    @Environment(\.dismiss) var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = sourceType
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.onImagePicked(image)
            }
            parent.dismiss()
        }
    }
}

#Preview {
    PhotoCaptureView()
}
