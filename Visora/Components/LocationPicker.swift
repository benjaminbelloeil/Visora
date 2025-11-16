//
//  LocationPicker.swift
//  Visora
//
//  Created on November 16, 2025.
//

import SwiftUI

struct LocationPicker: View {
    @Binding var selectedLocation: String
    @State private var searchText = ""
    @State private var showPicker = false
    var hasCheckmark: Bool = false
    
    // Popular cities and countries
    private let locations = [
        "New York, USA",
        "London, UK",
        "Paris, France",
        "Tokyo, Japan",
        "Dubai, UAE",
        "Singapore, Singapore",
        "Barcelona, Spain",
        "Rome, Italy",
        "Amsterdam, Netherlands",
        "Istanbul, Turkey",
        "Bangkok, Thailand",
        "Sydney, Australia",
        "Toronto, Canada",
        "Berlin, Germany",
        "Mumbai, India",
        "Shanghai, China",
        "São Paulo, Brazil",
        "Mexico City, Mexico",
        "Seoul, South Korea",
        "Cairo, Egypt",
        "Moscow, Russia",
        "Athens, Greece",
        "Stockholm, Sweden",
        "Vienna, Austria",
        "Prague, Czech Republic",
        "Budapest, Hungary",
        "Lisbon, Portugal",
        "Copenhagen, Denmark",
        "Oslo, Norway",
        "Helsinki, Finland",
        "Warsaw, Poland",
        "Brussels, Belgium",
        "Zurich, Switzerland",
        "Dublin, Ireland",
        "Reykjavik, Iceland",
        "Dhaka, Bangladesh",
        "Sylhet, Bangladesh",
        "Chittagong, Bangladesh",
        "Khulna, Bangladesh",
        "Los Angeles, USA",
        "Chicago, USA",
        "San Francisco, USA",
        "Miami, USA",
        "Las Vegas, USA",
        "Seattle, USA",
        "Boston, USA",
        "Washington DC, USA",
        "Vancouver, Canada",
        "Montreal, Canada",
        "Hong Kong, China",
        "Beijing, China",
        "Bangalore, India",
        "Delhi, India",
        "Kolkata, India",
        "Chennai, India",
        "Kuala Lumpur, Malaysia",
        "Manila, Philippines",
        "Jakarta, Indonesia",
        "Hanoi, Vietnam",
        "Ho Chi Minh City, Vietnam",
        "Bali, Indonesia",
        "Phuket, Thailand",
        "Florence, Italy",
        "Venice, Italy",
        "Milan, Italy",
        "Naples, Italy",
        "Madrid, Spain",
        "Valencia, Spain",
        "Seville, Spain",
        "Lyon, France",
        "Marseille, France",
        "Nice, France",
        "Munich, Germany",
        "Hamburg, Germany",
        "Frankfurt, Germany",
        "Manchester, UK",
        "Edinburgh, UK",
        "Glasgow, UK",
        "Birmingham, UK"
    ].sorted()
    
    private var filteredLocations: [String] {
        if searchText.isEmpty {
            return locations
        } else {
            return locations.filter { $0.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Location")
                .font(.subheadline)
                .foregroundColor(.textColor)
            
            Button {
                showPicker = true
            } label: {
                HStack {
                    Text(selectedLocation.isEmpty ? "Select Location" : selectedLocation)
                        .foregroundColor(selectedLocation.isEmpty ? .subTextColor : .textColor)
                    
                    Spacer()
                    
                    if hasCheckmark && !selectedLocation.isEmpty {
                        Image(systemName: "checkmark")
                            .foregroundColor(.actionColor)
                            .font(.caption)
                    }
                    
                    Image(systemName: "chevron.down")
                        .foregroundColor(.subTextColor)
                        .font(.caption)
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                .background(Color(UIColor.secondarySystemBackground))
                .cornerRadius(8)
            }
        }
        .sheet(isPresented: $showPicker) {
            NavigationStack {
                List {
                    ForEach(filteredLocations, id: \.self) { location in
                        Button {
                            selectedLocation = location
                            showPicker = false
                        } label: {
                            HStack {
                                Text(location)
                                    .foregroundColor(.textColor)
                                
                                Spacer()
                                
                                if selectedLocation == location {
                                    Image(systemName: "checkmark")
                                        .foregroundColor(.actionColor)
                                }
                            }
                        }
                    }
                }
                .navigationTitle("Select Location")
                .navigationBarTitleDisplayMode(.inline)
                .searchable(text: $searchText, prompt: "Search cities and countries")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button("Done") {
                            showPicker = false
                        }
                        .foregroundColor(.actionColor)
                    }
                }
            }
        }
    }
}

#Preview {
    LocationPicker(selectedLocation: .constant("Sylhet, Bangladesh"), hasCheckmark: true)
        .padding()
}
