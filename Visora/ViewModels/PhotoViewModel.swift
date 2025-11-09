//
//  PhotoViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import UIKit
import Combine

@MainActor
class PhotoViewModel: ObservableObject {
    @Published var currentPhoto: PhotoEntry?
    @Published var isProcessing = false
    
    func processPhoto(_ image: UIImage) async {
        isProcessing = true
        
        // Simulate AI processing
        try? await Task.sleep(nanoseconds: 2_000_000_000) // 2 seconds
        
        // Create a sample photo entry
        currentPhoto = PhotoEntry(
            imageName: "captured_photo",
            dateTaken: Date(),
            location: "Sample Location",
            caption: "AI-generated description of the captured photo",
            locationName: "Sample Place",
            aiDescription: "This appears to be a beautiful scenic location."
        )
        
        isProcessing = false
        
        // TODO: Implement actual AI processing
    }
    
    func reset() {
        currentPhoto = nil
        isProcessing = false
    }
}
