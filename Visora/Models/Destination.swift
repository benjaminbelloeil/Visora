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
    let fact1: String?
    let fact2: String?
    let fact3: String?
    
    init(
        id: String = UUID().uuidString,
        name: String,
        description: String,
        imageName: String,
        coordinate: CLLocationCoordinate2D,
        country: String,
        category: String? = nil,
        rating: Double? = nil,
        visitorCount: Int? = nil,
        fact1: String? = nil,
        fact2: String? = nil,
        fact3: String? = nil
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
        self.fact1 = fact1
        self.fact2 = fact2
        self.fact3 = fact3
    }
    
    enum CodingKeys: String, CodingKey {
        case id, name, description, imageName, country, category, rating, visitorCount, fact1, fact2, fact3
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
        fact1 = try container.decodeIfPresent(String.self, forKey: .fact1)
        fact2 = try container.decodeIfPresent(String.self, forKey: .fact2)
        fact3 = try container.decodeIfPresent(String.self, forKey: .fact3)
        
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
        try container.encodeIfPresent(fact1, forKey: .fact1)
        try container.encodeIfPresent(fact2, forKey: .fact2)
        try container.encodeIfPresent(fact3, forKey: .fact3)
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
            visitorCount: 50,
            fact1: "Built in 1889 for the World's Fair and was meant to be temporary",
            fact2: "Stands 330 meters tall with three observation levels",
            fact3: "Sparkles with 20,000 golden lights every evening"
        ),
        Destination(
            name: "Taj Mahal",
            description: "The Taj Mahal is an ivory-white marble mausoleum and one of the most beautiful buildings in the world. Built by Mughal emperor Shah Jahan in memory of his beloved wife Mumtaz Mahal, this UNESCO World Heritage Site took 22 years to complete. The monument's stunning symmetry, intricate marble inlay work, and gorgeous gardens create an unforgettable sight. The white marble changes color throughout the day, appearing pink at sunrise, white during the day, and golden under moonlight. This eternal symbol of love attracts millions of visitors annually who come to witness its breathtaking beauty.",
            imageName: "Destination2",
            coordinate: CLLocationCoordinate2D(latitude: 27.1751, longitude: 78.0421),
            country: "Agra, India",
            category: "Monument",
            rating: 4.9,
            visitorCount: 150,
            fact1: "Commissioned in 1632 by Shah Jahan for his wife Mumtaz Mahal",
            fact2: "Took 22 years and 20,000 artisans to complete",
            fact3: "Made entirely of white marble with semi-precious stone inlays"
        ),
        Destination(
            name: "Colosseum",
            description: "The Colosseum stands as the largest ancient amphitheater ever built and remains one of Rome's most iconic landmarks. Constructed between 70-80 AD, this architectural marvel could hold up to 80,000 spectators who gathered to witness gladiatorial contests, animal hunts, and dramatic reenactments. Walking through its ancient corridors, you can almost hear the roar of the crowds and feel the weight of history. The ingenious engineering, including underground tunnels and a sophisticated drainage system, showcases Roman innovation. Today, the Colosseum is a UNESCO World Heritage Site and one of the New Seven Wonders of the World, attracting millions of visitors who come to experience this testament to the grandeur of the Roman Empire.",
            imageName: "Destination3",
            coordinate: CLLocationCoordinate2D(latitude: 41.8902, longitude: 12.4922),
            country: "Rome, Italy",
            category: "Historical",
            rating: 4.9,
            visitorCount: 200,
            fact1: "Built between 70-80 AD during the Flavian dynasty",
            fact2: "Could hold 50,000 to 80,000 spectators for gladiatorial games",
            fact3: "UNESCO World Heritage Site and New Seven Wonders of the World"
        ),
        Destination(
            name: "Statue of Liberty",
            description: "The Statue of Liberty stands as a powerful symbol of freedom and democracy, welcoming millions to New York Harbor since 1886. This colossal neoclassical sculpture was a gift from France to the United States, designed by French sculptor Frédéric Auguste Bartholdi. Standing 305 feet tall from ground to torch, Lady Liberty holds a torch above her head with her right hand and carries a tablet inscribed with the date of American independence in her left. Visitors can climb the 354 steps to the crown for spectacular views of New York City and the harbor. The statue represents opportunity, hope, and the enduring friendship between nations.",
            imageName: "Destination4",
            coordinate: CLLocationCoordinate2D(latitude: 40.6892, longitude: -74.0445),
            country: "New York, USA",
            category: "Monument",
            rating: 4.8,
            visitorCount: 180,
            fact1: "Gift from France, dedicated on October 28, 1886",
            fact2: "Made of copper sheets assembled on a framework of steel",
            fact3: "The crown has 25 windows symbolizing gemstones and heaven's rays"
        ),
        Destination(
            name: "Christ the Redeemer",
            description: "Christ the Redeemer is an iconic Art Deco statue of Jesus Christ overlooking Rio de Janeiro from atop Mount Corcovado. Standing 98 feet tall with arms stretched 92 feet wide, this magnificent monument has become a cultural icon of both Rio and Brazil. Constructed between 1922 and 1931, the statue is made of reinforced concrete and soapstone. The panoramic views from the base offer breathtaking vistas of the city, Sugarloaf Mountain, and Guanabara Bay. Voted one of the New Seven Wonders of the World, this masterpiece combines religious symbolism with stunning architectural achievement.",
            imageName: "Destination5",
            coordinate: CLLocationCoordinate2D(latitude: -22.9519, longitude: -43.2105),
            country: "Rio de Janeiro, Brazil",
            category: "Monument",
            rating: 4.8,
            visitorCount: 160,
            fact1: "Built between 1922-1931, stands 98 feet tall atop Corcovado Mountain",
            fact2: "Arms stretch 92 feet wide, weighing 635 metric tons",
            fact3: "One of the New Seven Wonders of the World since 2007"
        )
    ]
}
