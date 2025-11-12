//
//  PhotoEntry.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import UIKit

struct PhotoEntry: Identifiable, Codable {
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
    
    // This property won't be codable but will be used for display
    var image: UIImage?
    
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
        fact3: String? = nil
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
    }
    
    enum CodingKeys: String, CodingKey {
        case id, imageName, dateTaken, location, caption, locationName, aiDescription, fact1, fact2, fact3
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
