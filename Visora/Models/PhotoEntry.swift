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
    
    // This property won't be codable but will be used for display
    var image: UIImage? {
        // In a real app, you'd load the image from imageName
        // For now, return nil as placeholder
        return nil
    }
    
    init(
        id: String = UUID().uuidString,
        imageName: String,
        dateTaken: Date,
        location: String? = nil,
        caption: String? = nil,
        locationName: String? = nil,
        aiDescription: String? = nil
    ) {
        self.id = id
        self.imageName = imageName
        self.dateTaken = dateTaken
        self.location = location
        self.caption = caption
        self.locationName = locationName
        self.aiDescription = aiDescription
    }
    
    enum CodingKeys: String, CodingKey {
        case id, imageName, dateTaken, location, caption, locationName, aiDescription
    }
}

// Sample data for preview and testing
extension PhotoEntry {
    static let sampleData: [PhotoEntry] = [
        PhotoEntry(
            imageName: "sample1",
            dateTaken: Date(),
            location: "Paris, France",
            caption: "Beautiful day at the Eiffel Tower",
            locationName: "Eiffel Tower",
            aiDescription: "Iconic iron lattice tower in Paris"
        ),
        PhotoEntry(
            imageName: "sample2",
            dateTaken: Date(),
            location: "London, UK",
            caption: "Exploring the city",
            locationName: "London Bridge",
            aiDescription: "Historic bridge over the Thames River"
        ),
        PhotoEntry(
            imageName: "sample3",
            dateTaken: Date(),
            location: "New York, USA",
            caption: "City lights at night",
            locationName: "Times Square",
            aiDescription: "Bustling commercial intersection and neighborhood"
        )
    ]
}
