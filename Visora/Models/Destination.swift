//
//  Destination.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import CoreLocation

struct Destination: Identifiable, Codable {
    let id: String
    let name: String
    let description: String
    let imageName: String
    let coordinate: CLLocationCoordinate2D
    let country: String
    let category: String?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        imageName: String,
        coordinate: CLLocationCoordinate2D,
        country: String,
        category: String? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.coordinate = coordinate
        self.country = country
        self.category = category
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, imageName, country, category
        case latitude = "coordinate.latitude"
        case longitude = "coordinate.longitude"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        description = try container.decode(String.self, forKey: .description)
        imageName = try container.decode(String.self, forKey: .imageName)
        country = try container.decode(String.self, forKey: .country)
        category = try container.decodeIfPresent(String.self, forKey: .category)
        
        let latitude = try container.decode(Double.self, forKey: .latitude)
        let longitude = try container.decode(Double.self, forKey: .longitude)
        coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(description, forKey: .description)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(country, forKey: .country)
        try container.encodeIfPresent(category, forKey: .category)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

extension Destination {
    static let sampleData: [Destination] = [
        Destination(
            name: "Paris",
            description: "The City of Light awaits with its romantic charm and iconic landmarks.",
            imageName: "paris",
            coordinate: CLLocationCoordinate2D(latitude: 48.8566, longitude: 2.3522),
            country: "France",
            category: "City"
        ),
        Destination(
            name: "Tokyo",
            description: "A vibrant metropolis blending traditional culture with cutting-edge technology.",
            imageName: "tokyo",
            coordinate: CLLocationCoordinate2D(latitude: 35.6762, longitude: 139.6503),
            country: "Japan",
            category: "City"
        ),
        Destination(
            name: "Bali",
            description: "Tropical paradise with stunning beaches and rich cultural heritage.",
            imageName: "bali",
            coordinate: CLLocationCoordinate2D(latitude: -8.3405, longitude: 115.0920),
            country: "Indonesia",
            category: "Island"
        )
    ]
}
