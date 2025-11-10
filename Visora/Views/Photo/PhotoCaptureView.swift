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
            VStack(spacing: 30) {
                if viewModel.isProcessing {
                    ProgressView("Analyzing photo...")
                        .padding()
                } else if let photoEntry = viewModel.currentPhoto {
                    PhotoResultView(photoEntry: photoEntry)
                        .environmentObject(viewModel)
                } else {
                    VStack(spacing: 40) {
                        Image(systemName: "camera.fill")
                            .font(.system(size: 80))
                            .foregroundColor(.actionColor)
                        
                        Text("Capture Your Adventure")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text("Take a photo or choose from your library to identify landmarks and destinations")
                            .multilineTextAlignment(.center)
                            .foregroundColor(.subTextColor)
                            .padding(.horizontal, 40)
                        
                        VStack(spacing: 16) {
                            PrimaryButton(title: "Take Photo") {
                                showingCamera = true
                            }
                            .padding(.horizontal, 40)
                            
                            PhotosPicker(selection: $selectedItem, matching: .images) {
                                Text("Choose from Library")
                                    .frame(maxWidth: .infinity)
                                    .padding()
                                    .background(Color.gray.opacity(0.2))
                                    .foregroundColor(.primary)
                                    .cornerRadius(12)
                            }
                            .padding(.horizontal, 40)
                        }
                    }
                }
            }
            .navigationTitle("Capture")
            .sheet(isPresented: $showingCamera) {
                ImagePicker(sourceType: .camera) { image in
                    Task {
                        await viewModel.processPhoto(image)
                    }
                }
            }
            .onChange(of: selectedItem) { _, newValue in
                Task {
                    if let data = try? await newValue?.loadTransferable(type: Data.self),
                       let image = UIImage(data: data) {
                        await viewModel.processPhoto(image)
                    }
                }
            }
        }
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
