//
//  PhotoViewModel.swift
//  Visora
//
//  Created on November 9, 2025.
//

import Foundation
import UIKit
import Combine
import Vision
import CoreLocation
import ImageIO
import Photos

@MainActor
class PhotoViewModel: ObservableObject {
    @Published var currentPhoto: PhotoEntry?
    @Published var isProcessing = false
    
    private let locationManager = CLLocationManager()
    
    // MARK: - Google Gemini API Configuration
    
    // API key is stored in Info.plist (in Target settings)
    // Free tier: 60 requests per minute, 1500 per day - PLENTY for a travel app!
    private var geminiAPIKey: String {
        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GEMINI_API_KEY") as? String else {
            print("⚠️ GEMINI_API_KEY not found in Info.plist")
            return ""
        }
        return apiKey
    }
    private let geminiEndpoint = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent"
    
    func processPhoto(_ image: UIImage, asset: PHAsset? = nil) async {
        isProcessing = true
        
        // Extract GPS location from photo EXIF data or PHAsset
        var gpsLocation: String?
        var gpsCoordinate: CLLocationCoordinate2D?
        
        // First try to get location from PHAsset (when selected from library)
        if let asset = asset, let location = asset.location {
            gpsCoordinate = location.coordinate
            gpsLocation = await reverseGeocode(location)
            print("📍 Got GPS from Photos library asset: \(gpsLocation ?? "nil") at (\(gpsCoordinate!.latitude), \(gpsCoordinate!.longitude))")
        } else {
            // Fallback to EXIF extraction (for camera photos)
            let extracted = await extractGPSLocationAndCoordinate(from: image)
            gpsLocation = extracted.location
            gpsCoordinate = extracted.coordinate
            print("📍 Got GPS from EXIF data: \(gpsLocation ?? "nil")")
        }
        
        // Use Google Gemini for AI-powered image analysis
        let geminiAnalysis = await analyzeWithGemini(image, gpsHint: gpsLocation)
        
        // Fallback to Vision framework if Gemini fails
        if let analysis = geminiAnalysis {
            // IMPORTANT: Use the actual GPS location from the photo, not AI's guess
            // Only use AI's location if we don't have GPS data
            let actualLocation = gpsLocation ?? analysis.location
            
            currentPhoto = PhotoEntry(
                image: image,
                imageName: "captured_photo_\(Date().timeIntervalSince1970)",
                dateTaken: Date(),
                location: actualLocation,  // Use GPS location if available
                caption: analysis.caption,
                locationName: analysis.locationName,
                aiDescription: analysis.description,
                fact1: analysis.fact1,
                fact2: analysis.fact2,
                fact3: analysis.fact3,
                latitude: gpsCoordinate?.latitude,
                longitude: gpsCoordinate?.longitude
            )
            
            print("📍 Final location used: \(actualLocation ?? "Unknown") (GPS: \(gpsLocation != nil ? "✓" : "✗"))")
        } else {
            // Fallback to local Vision analysis
            let visionAnalysis = await analyzeImageWithVision(image)
            currentPhoto = PhotoEntry(
                image: image,
                imageName: "captured_photo_\(Date().timeIntervalSince1970)",
                dateTaken: Date(),
                location: gpsLocation ?? visionAnalysis.location,
                caption: visionAnalysis.caption,
                locationName: visionAnalysis.locationName,
                aiDescription: visionAnalysis.description,
                fact1: nil,
                fact2: nil,
                fact3: nil,
                latitude: gpsCoordinate?.latitude,
                longitude: gpsCoordinate?.longitude
            )
        }
        
        // Save to calendar only if we have valid location data
        if let photo = currentPhoto,
           let locationName = photo.locationName,
           !locationName.isEmpty {
            // Filter out invalid locations
            let invalidKeywords = ["unknown", "location not determined", "ensure", "api", "configured", "captured scene"]
            let lowercasedName = locationName.lowercased()
            let isInvalid = invalidKeywords.contains { lowercasedName.contains($0) }
            
            if !isInvalid {
                CalendarViewModel.shared.savePhoto(photo)
                print("✅ Photo saved to calendar: \(locationName)")
            } else {
                print("❌ Photo NOT saved - invalid location: \(locationName)")
            }
        } else {
            print("❌ Photo NOT saved - no location name")
        }
        
        isProcessing = false
    }
    
    func reset() {
        currentPhoto = nil
        isProcessing = false
    }
    
    // MARK: - GPS Location Extraction
    
    private func extractGPSLocationAndCoordinate(from image: UIImage) async -> (location: String?, coordinate: CLLocationCoordinate2D?) {
        // Get EXIF metadata from image
        guard let imageData = image.jpegData(compressionQuality: 1.0),
              let imageSource = CGImageSourceCreateWithData(imageData as CFData, nil),
              let metadata = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any],
              let gpsData = metadata[kCGImagePropertyGPSDictionary as String] as? [String: Any] else {
            print("📍 No GPS data found in image EXIF")
            return (nil, nil)
        }
        
        // Extract latitude and longitude
        guard let latitude = gpsData[kCGImagePropertyGPSLatitude as String] as? Double,
              let longitude = gpsData[kCGImagePropertyGPSLongitude as String] as? Double,
              let latRef = gpsData[kCGImagePropertyGPSLatitudeRef as String] as? String,
              let lonRef = gpsData[kCGImagePropertyGPSLongitudeRef as String] as? String else {
            print("📍 GPS data incomplete")
            return (nil, nil)
        }
        
        // Adjust signs based on hemisphere
        let finalLatitude = latRef == "S" ? -latitude : latitude
        let finalLongitude = lonRef == "W" ? -longitude : longitude
        
        print("📍 GPS coordinates: \(finalLatitude), \(finalLongitude)")
        
        // Reverse geocode to get location name
        let clLocation = CLLocation(latitude: finalLatitude, longitude: finalLongitude)
        let locationString = await reverseGeocode(clLocation)
        let coordinate = CLLocationCoordinate2D(latitude: finalLatitude, longitude: finalLongitude)
        
        return (locationString, coordinate)
    }
    
    private func reverseGeocode(_ location: CLLocation) async -> String? {
        let geocoder = CLGeocoder()
        
        do {
            let placemarks = try await geocoder.reverseGeocodeLocation(location)
            if let placemark = placemarks.first {
                var locationParts: [String] = []
                
                // Add sublocality or locality (city/town) - prefer sublocality for more specific areas
                if let subLocality = placemark.subLocality {
                    locationParts.append(subLocality)
                } else if let locality = placemark.locality {
                    locationParts.append(locality)
                }
                
                // Add country
                if let country = placemark.country {
                    locationParts.append(country)
                }
                
                let locationString = locationParts.joined(separator: ", ")
                print("📍 Reverse geocoded to: \(locationString)")
                print("   Full placemark details: locality=\(placemark.locality ?? "nil"), subLocality=\(placemark.subLocality ?? "nil"), administrativeArea=\(placemark.administrativeArea ?? "nil")")
                return locationString.isEmpty ? nil : locationString
            }
        } catch {
            print("📍 Reverse geocoding failed: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    // MARK: - Google Gemini Vision API
    
    private func analyzeWithGemini(_ image: UIImage, gpsHint: String?) async -> (location: String, locationName: String, caption: String, description: String, fact1: String, fact2: String, fact3: String)? {
        // Check if API key is set
        guard geminiAPIKey != "YOUR_GEMINI_API_KEY_HERE" && !geminiAPIKey.isEmpty else {
            print("⚠️ Gemini API key not set. Get your FREE key at: https://makersuite.google.com/app/apikey")
            return nil
        }
        
        print("🔍 Analyzing image with Gemini AI...")
        if let gps = gpsHint {
            print("📍 GPS location hint: \(gps)")
        }
        
        // Convert image to base64
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        let base64Image = imageData.base64EncodedString()
        
        // Create detailed prompt for travel analysis with optional GPS hint
        let gpsPromptAddition = gpsHint != nil ? "\n\n⚠️ IMPORTANT: This photo was taken at GPS location: \(gpsHint!). The 'location' field must be exactly this: '\(gpsHint!)'. Use this GPS data to help identify the specific landmark or attraction that is visible near this location in the image." : ""
        
        let prompt = """
        You are an expert travel guide analyzing a photo. Provide a detailed analysis in JSON format with these exact fields:
        
        {
          "locationName": "The specific name of the landmark, monument, city, or natural feature visible in the image (e.g., 'Solfatara Crater', 'Rione Terra', 'Flavian Amphitheater')",
          "location": "Full location with city and country - USE THE GPS LOCATION PROVIDED IF AVAILABLE",
          "caption": "A short 3-5 word description (e.g., 'Ancient volcanic crater', 'Historic waterfront district')",
          "description": "A detailed 3-4 sentence description including: what this place is, its historical/cultural significance, interesting facts, and why it's worth visiting",
          "fact1": "First interesting historical or cultural fact",
          "fact2": "Second interesting fact about visitor experience or significance",
          "fact3": "Third architectural or cultural fact"
        }\(gpsPromptAddition)
        
        Be specific with landmark names. If GPS location is provided, you MUST use it exactly for the 'location' field. Identify the specific landmark or attraction near that GPS location.
        
        Respond ONLY with valid JSON, no other text.
        """
        
        // Create request payload for Gemini
        let payload: [String: Any] = [
            "contents": [
                [
                    "parts": [
                        [
                            "text": prompt
                        ],
                        [
                            "inline_data": [
                                "mime_type": "image/jpeg",
                                "data": base64Image
                            ]
                        ]
                    ]
                ]
            ],
            "generationConfig": [
                "temperature": 0.4,
                "maxOutputTokens": 500
            ]
        ]
        
        // Build URL with API key
        guard let baseURL = URL(string: geminiEndpoint),
              var components = URLComponents(url: baseURL, resolvingAgainstBaseURL: true) else {
            return nil
        }
        components.queryItems = [URLQueryItem(name: "key", value: geminiAPIKey)]
        
        guard let url = components.url,
              let jsonData = try? JSONSerialization.data(withJSONObject: payload) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        request.timeoutInterval = 30
        
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid HTTP response from Gemini")
                return nil
            }
            
            print("📡 Gemini API response status: \(httpResponse.statusCode)")
            
            if httpResponse.statusCode != 200 {
                if let errorJson = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    print("❌ Gemini API error: \(errorJson)")
                } else if let errorString = String(data: data, encoding: .utf8) {
                    print("❌ Gemini error response: \(errorString)")
                }
                return nil
            }
            
            // Parse Gemini response
            if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
               let candidates = json["candidates"] as? [[String: Any]],
               let firstCandidate = candidates.first,
               let content = firstCandidate["content"] as? [String: Any],
               let parts = content["parts"] as? [[String: Any]],
               let firstPart = parts.first,
               let text = firstPart["text"] as? String {
                
                print("✅ Gemini response received, parsing...")
                // Parse the JSON response from Gemini
                return parseGeminiResponse(text)
            } else {
                print("❌ Failed to parse Gemini response structure")
                if let debugJson = try? JSONSerialization.jsonObject(with: data) {
                    print("Debug - Full response: \(debugJson)")
                }
            }
            
        } catch {
            print("❌ Gemini request error: \(error.localizedDescription)")
        }
        
        return nil
    }
    
    private func parseGeminiResponse(_ text: String) -> (location: String, locationName: String, caption: String, description: String, fact1: String, fact2: String, fact3: String)? {
        print("📝 Parsing Gemini text: \(text.prefix(100))...")
        
        // Clean up the response - remove markdown code blocks if present
        var cleanedText = text
        if cleanedText.contains("```json") {
            cleanedText = cleanedText.replacingOccurrences(of: "```json", with: "")
        }
        if cleanedText.contains("```") {
            cleanedText = cleanedText.replacingOccurrences(of: "```", with: "")
        }
        cleanedText = cleanedText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Parse JSON
        guard let jsonData = cleanedText.data(using: .utf8),
              let json = try? JSONSerialization.jsonObject(with: jsonData) as? [String: String] else {
            print("❌ Failed to parse Gemini JSON response")
            print("Cleaned text was: \(cleanedText)")
            return nil
        }
        
        print("✅ Successfully parsed JSON from Gemini!")
        
        let locationName = json["locationName"] ?? "Unknown Location"
        let location = json["location"] ?? "Unknown"
        let caption = json["caption"] ?? "Scenic location"
        let description = json["description"] ?? "This location has been analyzed and saved."
        let fact1 = json["fact1"] ?? "Interesting historical location"
        let fact2 = json["fact2"] ?? "Popular tourist destination"
        let fact3 = json["fact3"] ?? "Rich cultural heritage"
        
        return (location: location, locationName: locationName, caption: caption, description: description, fact1: fact1, fact2: fact2, fact3: fact3)
    }
    
    // MARK: - Vision Framework Analysis (Fallback & Enhancement)
    
    // MARK: - Vision Framework Analysis (Fallback & Enhancement)
    
    private func analyzeImageWithVision(_ image: UIImage) async -> (location: String, locationName: String, caption: String, description: String) {
        guard let cgImage = image.cgImage else {
            return getDefaultAnalysis()
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        var detectedScenes: [String] = []
        
        // Scene Classification Request
        let sceneRequest = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else { return }
            detectedScenes = observations.prefix(5).map { $0.identifier }
        }
        
        // Perform requests
        do {
            try requestHandler.perform([sceneRequest])
        } catch {
            print("Vision request failed: \(error)")
            return getDefaultAnalysis()
        }
        
        return generateAnalysisFromDetections(
            scenes: detectedScenes,
            confidence: 0.0
        )
    }
    
    private func generateAnalysisFromDetections(
        scenes: [String],
        confidence: Float
    ) -> (location: String, locationName: String, caption: String, description: String) {
        
        // Simplified fallback - Gemini handles the detailed analysis
        let locationName = scenes.first?.replacingOccurrences(of: "_", with: " ").capitalized ?? "Unknown Location"
        let location = "Location not determined"
        let caption = "Captured moment"
        let description = "This image has been captured. For detailed analysis, please ensure Gemini API is configured."
        
        return (location: location, locationName: locationName, caption: caption, description: description)
    }
    
    private func categorizeScene(_ scenes: [String]) -> (name: String, location: String, caption: String, description: String) {
        return (
            name: scenes.first?.capitalized.replacingOccurrences(of: "_", with: " ") ?? "Interesting Location",
            location: "Unknown",
            caption: "Scenic location",
            description: "This image captures an interesting location worth documenting."
        )
    }
    
    private func detectLandmarkFromText(_ text: [String]) -> String? {
        // Gemini handles landmark detection, so this is just a minimal fallback
        return nil
    }
    
    private func getLandmarkInfo(_ name: String) -> (location: String, locationName: String, caption: String, description: String) {
        // Gemini provides all landmark info, this is just a minimal fallback
        return (
            location: "Unknown",
            locationName: name,
            caption: "Notable landmark",
            description: "This is \(name), a significant location worth visiting."
        )
    }
    
    private func getDefaultAnalysis() -> (location: String, locationName: String, caption: String, description: String) {
        return (
            location: "Unknown Location",
            locationName: "Captured Scene",
            caption: "Moment captured",
            description: "This image has been captured and saved for your review."
        )
    }
}

