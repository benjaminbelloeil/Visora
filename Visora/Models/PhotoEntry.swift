//
//  PhotoEntry.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import UIKit
import CoreLocation

struct PhotoEntry: Identifiable, Codable, Hashable {
    let id: String
    let imageName: String
    let dateTaken: Date
    let location: String?
    let caption: String?
    let locationName: String?
    let aiDescription: String?
    let fact1: String?
    let fact2: String?
    let fact3: String?
    let latitude: Double?
    let longitude: Double?
    var isFavorite: Bool  // Changed to var so it can be toggled
    
    // This property won't be codable but will be used for display
    var image: UIImage?
    
    // Computed property for coordinate
    var coordinate: CLLocationCoordinate2D? {
        guard let lat = latitude, let lon = longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lon)
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: PhotoEntry, rhs: PhotoEntry) -> Bool {
        lhs.id == rhs.id
    }
    
    init(
        id: String = UUID().uuidString,
        image: UIImage? = nil,
        imageName: String,
        dateTaken: Date,
        location: String? = nil,
        caption: String? = nil,
        locationName: String? = nil,
        aiDescription: String? = nil,
        fact1: String? = nil,
        fact2: String? = nil,
        fact3: String? = nil,
        latitude: Double? = nil,
        longitude: Double? = nil,
        isFavorite: Bool = false
    ) {
        self.id = id
        self.image = image
        self.imageName = imageName
        self.dateTaken = dateTaken
        self.location = location
        self.caption = caption
        self.locationName = locationName
        self.aiDescription = aiDescription
        self.fact1 = fact1
        self.fact2 = fact2
        self.fact3 = fact3
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
    
    enum CodingKeys: String, CodingKey {
        case id, imageName, dateTaken, location, caption, locationName, aiDescription, fact1, fact2, fact3, latitude, longitude, isFavorite
    }
    
    // Custom decoding - image will be loaded separately from file system
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        imageName = try container.decode(String.self, forKey: .imageName)
        dateTaken = try container.decode(Date.self, forKey: .dateTaken)
        location = try container.decodeIfPresent(String.self, forKey: .location)
        caption = try container.decodeIfPresent(String.self, forKey: .caption)
        locationName = try container.decodeIfPresent(String.self, forKey: .locationName)
        aiDescription = try container.decodeIfPresent(String.self, forKey: .aiDescription)
        fact1 = try container.decodeIfPresent(String.self, forKey: .fact1)
        fact2 = try container.decodeIfPresent(String.self, forKey: .fact2)
        fact3 = try container.decodeIfPresent(String.self, forKey: .fact3)
        latitude = try container.decodeIfPresent(Double.self, forKey: .latitude)
        longitude = try container.decodeIfPresent(Double.self, forKey: .longitude)
        isFavorite = try container.decodeIfPresent(Bool.self, forKey: .isFavorite) ?? false
        image = nil // Will be loaded separately
    }
    
    // Custom encoding - image is stored separately
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(imageName, forKey: .imageName)
        try container.encode(dateTaken, forKey: .dateTaken)
        try container.encodeIfPresent(location, forKey: .location)
        try container.encodeIfPresent(caption, forKey: .caption)
        try container.encodeIfPresent(locationName, forKey: .locationName)
        try container.encodeIfPresent(aiDescription, forKey: .aiDescription)
        try container.encodeIfPresent(fact1, forKey: .fact1)
        try container.encodeIfPresent(fact2, forKey: .fact2)
        try container.encodeIfPresent(fact3, forKey: .fact3)
        try container.encodeIfPresent(latitude, forKey: .latitude)
        try container.encodeIfPresent(longitude, forKey: .longitude)
        try container.encode(isFavorite, forKey: .isFavorite)
    }
}


// Sample data for preview and testing
extension PhotoEntry {
    static let sampleData: [PhotoEntry] = [
        PhotoEntry(
            imageName: "sample1",
            dateTaken: Date(),
            location: "Paris, France",
            caption: "Iconic Parisian landmark",
            locationName: "Eiffel Tower",
            aiDescription: "The Eiffel Tower is a wrought-iron lattice tower located in Paris, France. Built in 1889, it stands at 330 meters tall and is one of the most recognizable structures in the world.",
            fact1: "Built in 1889 for the World's Fair",
            fact2: "Most visited paid monument in the world",
            fact3: "Named after engineer Gustave Eiffel"
        )
    ]
}
