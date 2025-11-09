//
//  PlaceAnnotation.swift
//  Visora
//
//  Created on November 9, 2025.
//

import SwiftUI
import CoreLocation

struct PlaceAnnotation: View {
    let place: Place
    
    var body: some View {
        VStack(spacing: 0) {
            Image(systemName: categoryIcon)
                .font(.title3)
                .foregroundColor(.white)
                .padding(8)
                .background(Color.accentColor)
                .clipShape(Circle())
                .shadow(radius: 4)
        }
    }
    
    private var categoryIcon: String {
        guard let category = place.category?.lowercased() else {
            return "mappin.circle.fill"
        }
        
        switch category {
        case "restaurant", "food":
            return "fork.knife"
        case "hotel", "lodging":
            return "bed.double.fill"
        case "landmark", "monument":
            return "building.columns.fill"
        case "museum":
            return "building.fill"
        case "park":
            return "tree.fill"
        case "shopping":
            return "bag.fill"
        default:
            return "mappin.circle.fill"
        }
    }
}

#Preview {
    PlaceAnnotation(
        place: Place(
            id: "1",
            name: "Eiffel Tower",
            coordinate: .init(latitude: 48.8584, longitude: 2.2945),
            category: "Landmark"
        )
    )
}
