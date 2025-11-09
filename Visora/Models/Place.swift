//
//  Place.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import CoreLocation

struct Place: Identifiable, Hashable {
    let id: String
    let name: String
    let coordinate: CLLocationCoordinate2D
    let category: String?
    let description: String?
    let address: String?
    let rating: Double?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        coordinate: CLLocationCoordinate2D,
        category: String? = nil,
        description: String? = nil,
        address: String? = nil,
        rating: Double? = nil
    ) {
        self.id = id
        self.name = name
        self.coordinate = coordinate
        self.category = category
        self.description = description
        self.address = address
        self.rating = rating
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Place, rhs: Place) -> Bool {
        lhs.id == rhs.id
    }
}

// Sample data for preview and testing
extension Place {
    static let sampleData: [Place] = [
        Place(
            name: "Eiffel Tower",
            coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
            category: "Landmark",
            description: "The iconic iron lattice tower in Paris.",
            address: "Champ de Mars, 5 Avenue Anatole France, 75007 Paris, France",
            rating: 4.7
        ),
        Place(
            name: "Louvre Museum",
            coordinate: CLLocationCoordinate2D(latitude: 48.8606, longitude: 2.3376),
            category: "Museum",
            description: "The world's largest art museum and a historic monument in Paris.",
            address: "Rue de Rivoli, 75001 Paris, France",
            rating: 4.8
        )
    ]
}
