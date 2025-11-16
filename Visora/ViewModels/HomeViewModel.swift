//
//  HomeViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var featuredDestinations: [Destination] = []
    @Published var isLoading = false
    
    static let shared = HomeViewModel()
    
    func loadFeaturedDestinations() {
        isLoading = true
        
        // Simulate loading destinations
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.featuredDestinations = Destination.sampleData
            self?.isLoading = false
        }
        
        // TODO: Replace with actual data loading
    }
    
    func preloadData() async {
        isLoading = true
        
        // Simulate data loading - wait for resources
        try? await Task.sleep(nanoseconds: 500_000_000) // 0.5 seconds
        
        featuredDestinations = Destination.sampleData
        isLoading = false
    }
}
