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
    let rating: Double?
    let visitorCount: Int?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        imageName: String,
        coordinate: CLLocationCoordinate2D,
        country: String,
        category: String? = nil,
        rating: Double? = nil,
        visitorCount: Int? = nil
    ) {
        self.id = id
        self.name = name
        self.description = description
        self.imageName = imageName
        self.coordinate = coordinate
        self.country = country
        self.category = category
        self.rating = rating
        self.visitorCount = visitorCount
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, imageName, country, category, rating, visitorCount
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
        rating = try container.decodeIfPresent(Double.self, forKey: .rating)
        visitorCount = try container.decodeIfPresent(Int.self, forKey: .visitorCount)
        
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
        try container.encodeIfPresent(rating, forKey: .rating)
        try container.encodeIfPresent(visitorCount, forKey: .visitorCount)
        try container.encode(coordinate.latitude, forKey: .latitude)
        try container.encode(coordinate.longitude, forKey: .longitude)
    }
}

extension Destination {
    static let sampleData: [Destination] = [
        Destination(
            name: "Eiffel Tower",
            description: "The Eiffel Tower stands as an iconic iron lattice tower and enduring symbol of Paris. Constructed in 1889 for the World's Fair, this architectural masterpiece rises 330 meters into the Parisian skyline. Visitors can ascend to three levels, with the top offering breathtaking panoramic views of the entire city. The tower sparkles with 20,000 golden lights every evening, creating a magical atmosphere. Whether you're enjoying a romantic dinner at the Jules Verne restaurant or simply admiring the structure from the Trocadéro Gardens, the Eiffel Tower remains one of the most photographed monuments in the world and a must-visit destination for anyone traveling to France.",
            imageName: "Destination1",
            coordinate: CLLocationCoordinate2D(latitude: 48.8584, longitude: 2.2945),
            country: "Paris, France",
            category: "Landmark",
            rating: 4.7,
            visitorCount: 50
        ),
        Destination(
            name: "Athens",
            description: "Athens, the historic capital of Greece, is a city where ancient history meets modern vibrant culture. Home to the magnificent Acropolis and the iconic Parthenon, Athens offers visitors a journey through 3,400 years of civilization. Wander through the charming Plaka neighborhood with its narrow streets and neoclassical architecture, explore world-class museums like the Acropolis Museum, and experience authentic Greek cuisine in traditional tavernas. The city's archaeological sites tell stories of democracy's birthplace, while contemporary Athens buzzes with art galleries, rooftop bars, and a thriving nightlife scene. From ancient temples to bustling markets, Athens perfectly balances its glorious past with dynamic present.",
            imageName: "Destination2",
            coordinate: CLLocationCoordinate2D(latitude: 36.3932, longitude: 25.4615),
            country: "Athens, Greece",
            category: "Historical City",
            rating: 4.8,
            visitorCount: 120
        ),
        Destination(
            name: "Colosseum",
            description: "The Colosseum stands as the largest ancient amphitheater ever built and remains one of Rome's most iconic landmarks. Constructed between 70-80 AD, this architectural marvel could hold up to 80,000 spectators who gathered to witness gladiatorial contests, animal hunts, and dramatic reenactments. Walking through its ancient corridors, you can almost hear the roar of the crowds and feel the weight of history. The ingenious engineering, including underground tunnels and a sophisticated drainage system, showcases Roman innovation. Today, the Colosseum is a UNESCO World Heritage Site and one of the New Seven Wonders of the World, attracting millions of visitors who come to experience this testament to the grandeur of the Roman Empire.",
            imageName: "Destination3",
            coordinate: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
            country: "Rome, Italy",
            category: "Historical",
            rating: 4.9,
            visitorCount: 200
        )
    ]
}
