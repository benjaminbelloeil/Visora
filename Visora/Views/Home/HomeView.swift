//
//  HomeView.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Featured section
                    Text("Discover")
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.horizontal)
                    
                    // Destination cards
                    ForEach(viewModel.featuredDestinations) { destination in
                        NavigationLink(destination: DestinationDetailView(destination: destination)) {
                            DestinationCard(destination: destination)
                                .padding(.horizontal)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Explore")
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                viewModel.loadFeaturedDestinations()
            }
        }
    }
}

#Preview {
    HomeView()
}
