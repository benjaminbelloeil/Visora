//
//  ViewAllDestinationsView.swift
//  Visora
//
//  Created by Visora on 2025-01-01.
//

import SwiftUI

struct ViewAllDestinationsView: View {
    @Environment(\.dismiss) private var dismiss
    @StateObject private var viewModel = HomeViewModel()
    @State private var searchText = ""
    @State private var currentPage = 0
    @State private var selectedCategory = "All"
    
    private let itemsPerPage = 6
    private let categories = ["All", "Beach", "Mountain", "City", "Adventure", "Cultural"]
    
    // Filtered destinations based on search and category
    private var filteredDestinations: [Destination] {
        var destinations = viewModel.featuredDestinations
        
        // Filter by category
        if selectedCategory != "All" {
            destinations = destinations.filter { destination in
                // You can add category property to Destination model
                // For now, using name as a simple filter
                true
            }
        }
        
        // Filter by search text
        if !searchText.isEmpty {
            destinations = destinations.filter { destination in
                destination.name.localizedCaseInsensitiveContains(searchText) ||
                destination.country.localizedCaseInsensitiveContains(searchText)
            }
        }
        
        return destinations
    }
    
    // Paginated destinations
    private var paginatedDestinations: [Destination] {
        let startIndex = currentPage * itemsPerPage
        let endIndex = min(startIndex + itemsPerPage, filteredDestinations.count)
        
        guard startIndex < filteredDestinations.count else { return [] }
        return Array(filteredDestinations[startIndex..<endIndex])
    }
    
    // Total pages
    private var totalPages: Int {
        max(1, Int(ceil(Double(filteredDestinations.count) / Double(itemsPerPage))))
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                // Background
                Color.appBackground
                    .ignoresSafeArea()
                
                VStack(spacing: 0) {
                    // Category filter
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(categories, id: \.self) { category in
                                Button {
                                    withAnimation {
                                        selectedCategory = category
                                        currentPage = 0 // Reset to first page
                                    }
                                } label: {
                                    Text(category)
                                        .font(.custom("Nunito Sans", size: 15))
                                        .fontWeight(selectedCategory == category ? .bold : .medium)
                                        .foregroundColor(selectedCategory == category ? .white : .textColor)
                                        .padding(.horizontal, 20)
                                        .padding(.vertical, 10)
                                        .background(
                                            RoundedRectangle(cornerRadius: 20)
                                                .fill(selectedCategory == category ? Color.actionColor : Color.cardSurface)
                                        )
                                }
                            }
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                    }
                    .background(Color.appBackground)
                    
                    // Results count
                    HStack {
                        Text("\(filteredDestinations.count) destination\(filteredDestinations.count == 1 ? "" : "s") found")
                            .font(.custom("Nunito Sans", size: 14))
                            .foregroundColor(.subTextColor)
                        Spacer()
                    }
                    .padding(.horizontal, 15)
                    .padding(.bottom, 10)
                    
                    // Destinations grid
                    if paginatedDestinations.isEmpty {
                        VStack(spacing: 20) {
                            Image(systemName: "magnifyingglass")
                                .font(.system(size: 50))
                                .foregroundColor(.subTextColor)
                            
                            Text("No destinations found")
                                .font(.custom("Montserrat-SemiBold", size: 18))
                                .foregroundColor(.textColor)
                            
                            if !searchText.isEmpty {
                                Text("Try adjusting your search")
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(.subTextColor)
                            }
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .padding(.top, 80)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.flexible(), spacing: 15),
                                GridItem(.flexible(), spacing: 15)
                            ], spacing: 20) {
                                ForEach(paginatedDestinations) { destination in
                                    DestinationCard(destination: destination)
                                        .scaleEffect(0.65)
                                }
                            }
                            .padding(.horizontal, 15)
                            .padding(.bottom, 20)
                        }
                    }
                    
                    Spacer()
                    
                    // Pagination controls
                    if totalPages > 1 {
                        VStack(spacing: 12) {
                            // Page indicators
                            HStack(spacing: 8) {
                                ForEach(0..<totalPages, id: \.self) { page in
                                    Circle()
                                        .fill(page == currentPage ? Color.actionColor : Color.secondary.opacity(0.3))
                                        .frame(width: page == currentPage ? 10 : 8, height: page == currentPage ? 10 : 8)
                                        .animation(.easeInOut, value: currentPage)
                                }
                            }
                            
                            // Navigation buttons
                            HStack(spacing: 20) {
                                Button {
                                    withAnimation {
                                        if currentPage > 0 {
                                            currentPage -= 1
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Image(systemName: "chevron.left")
                                        Text("Previous")
                                    }
                                    .font(.custom("Nunito Sans", size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(currentPage > 0 ? .actionColor : .secondary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(currentPage > 0 ? Color.actionColor : Color.secondary, lineWidth: 1.5)
                                    )
                                }
                                .disabled(currentPage == 0)
                                
                                Text("Page \(currentPage + 1) of \(totalPages)")
                                    .font(.custom("Nunito Sans", size: 14))
                                    .foregroundColor(.textColor)
                                
                                Button {
                                    withAnimation {
                                        if currentPage < totalPages - 1 {
                                            currentPage += 1
                                        }
                                    }
                                } label: {
                                    HStack {
                                        Text("Next")
                                        Image(systemName: "chevron.right")
                                    }
                                    .font(.custom("Nunito Sans", size: 15))
                                    .fontWeight(.semibold)
                                    .foregroundColor(currentPage < totalPages - 1 ? .actionColor : .secondary)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 10)
                                    .background(
                                        RoundedRectangle(cornerRadius: 20)
                                            .stroke(currentPage < totalPages - 1 ? Color.actionColor : Color.secondary, lineWidth: 1.5)
                                    )
                                }
                                .disabled(currentPage >= totalPages - 1)
                            }
                        }
                        .padding(.bottom, 20)
                        .background(Color.appBackground)
                    }
                }
            }
            .navigationTitle("All Destinations")
            .navigationBarTitleDisplayMode(.large)
            .searchable(text: $searchText, prompt: "Search destinations...")
            .onChange(of: searchText) { _ in
                currentPage = 0 // Reset to first page on search
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 16, weight: .semibold))
                            .foregroundColor(.textColor)
                    }
                }
            }
        }
    }
}

#Preview {
    ViewAllDestinationsView()
}
