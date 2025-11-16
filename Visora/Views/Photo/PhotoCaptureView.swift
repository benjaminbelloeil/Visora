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
                    // Beautiful AI Analysis Loading Screen with smooth animations
                    AILoadingView(isProcessing: viewModel.isProcessing)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
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
            .animation(.easeInOut(duration: 0.6), value: viewModel.isProcessing)
            .animation(.easeInOut(duration: 0.6), value: viewModel.currentPhoto != nil)
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

// AI Loading Animation View
struct AILoadingView: View {
    let isProcessing: Bool
    @State private var rotationDegrees: Double = 0
    @State private var outerRotation: Double = 0
    @State private var pulseScale: CGFloat = 1.0
    @State private var sparkleRotation: Double = 0
    @State private var waveOffset: CGFloat = 0
    
    var body: some View {
        VStack(spacing: 40) {
            // Animation container
            animatedRings
            
            // Text content
            textContent
            
            // Progress dots
            progressDots
        }
    }
    
    // MARK: - Animated Rings
    private var animatedRings: some View {
        ZStack {
            outerRing
            middleRing
            innerRing
            sparkles
            brainIcon
        }
        .padding(.top, 50)
    }
    
    private var outerRing: some View {
        Circle()
            .trim(from: 0, to: 0.7)
            .stroke(
                LinearGradient(
                    colors: [Color.actionColor, Color.actionColor.opacity(0.3)],
                    startPoint: .leading,
                    endPoint: .trailing
                ),
                style: StrokeStyle(lineWidth: 4, lineCap: .round)
            )
            .frame(width: 180, height: 180)
            .rotationEffect(.degrees(outerRotation))
            .onAppear {
                withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
                    outerRotation = 360
                }
            }
    }
    
    private var middleRing: some View {
        Circle()
            .stroke(Color.actionColor.opacity(0.3), lineWidth: 3)
            .frame(width: 150, height: 150)
            .scaleEffect(pulseScale)
            .onAppear {
                withAnimation(.easeInOut(duration: 1.5).repeatForever(autoreverses: true)) {
                    pulseScale = 1.15
                }
            }
    }
    
    private var innerRing: some View {
        Circle()
            .trim(from: 0, to: 0.5)
            .stroke(
                Color.actionColor.opacity(0.4),
                style: StrokeStyle(lineWidth: 3, lineCap: .round)
            )
            .frame(width: 120, height: 120)
            .rotationEffect(.degrees(-rotationDegrees))
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotationDegrees = 360
                }
            }
    }
    
    private var sparkles: some View {
        ForEach(0..<8) { index in
            sparkleView(at: index)
        }
    }
    
    private func sparkleView(at index: Int) -> some View {
        let angle = sparkleRotation + Double(index) * 45
        let phase = angle * .pi / 180 + Double(index) * .pi / 4
        let opacity = 0.6 + sin(phase) * 0.4
        let scale = 0.8 + sin(phase) * 0.3
        
        return Image(systemName: "sparkle")
            .font(.system(size: 14, weight: .bold))
            .foregroundColor(.actionColor)
            .offset(y: -70)
            .rotationEffect(.degrees(angle))
            .opacity(opacity)
            .scaleEffect(scale)
            .onAppear {
                if index == 0 {
                    withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                        sparkleRotation = 360
                    }
                }
            }
    }
    
    private var brainIcon: some View {
        ZStack {
            glowEffect
            mainCircle
            brain
        }
    }
    
    private var glowEffect: some View {
        Circle()
            .fill(
                RadialGradient(
                    colors: [Color.actionColor.opacity(0.4), Color.clear],
                    center: .center,
                    startRadius: 20,
                    endRadius: 60
                )
            )
            .frame(width: 120, height: 120)
            .scaleEffect(pulseScale)
    }
    
    private var mainCircle: some View {
        Circle()
            .fill(
                LinearGradient(
                    colors: [Color.actionColor, Color.actionColor.opacity(0.8)],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .frame(width: 90, height: 90)
            .shadow(color: Color.actionColor.opacity(0.5), radius: 15, x: 0, y: 5)
    }
    
    private var brain: some View {
        Image(systemName: "brain.head.profile")
            .font(.system(size: 40, weight: .medium))
            .foregroundColor(.white)
            .rotationEffect(.degrees(rotationDegrees * 0.3))
    }
    
    // MARK: - Text Content
    private var textContent: some View {
        VStack(spacing: 16) {
            titleText
            descriptionText
        }
    }
    
    private var titleText: some View {
        Text("AI Analysis in Progress")
            .font(.system(size: 26, weight: .bold))
            .foregroundColor(.textColor)
            .scaleEffect(pulseScale > 1.07 ? 1.02 : 1.0)
    }
    
    private var descriptionText: some View {
        let textOpacity = 0.7 + sin(waveOffset) * 0.3
        
        return Text("Discovering the story behind your photo...")
            .font(.body)
            .foregroundColor(.subTextColor)
            .multilineTextAlignment(.center)
            .padding(.horizontal, 40)
            .opacity(textOpacity)
            .onAppear {
                withAnimation(.easeInOut(duration: 2).repeatForever(autoreverses: true)) {
                    waveOffset = .pi * 2
                }
            }
    }
    
    // MARK: - Progress Dots
    private var progressDots: some View {
        HStack(spacing: 12) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.actionColor)
                    .frame(width: 12, height: 12)
                    .scaleEffect(pulseScale > 1.07 ? 1.0 : 0.5)
                    .animation(
                        Animation
                            .easeInOut(duration: 0.6)
                            .repeatForever()
                            .delay(Double(index) * 0.2),
                        value: pulseScale
                    )
            }
        }
        .padding(.top, 10)
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
