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

@MainActor
class PhotoViewModel: ObservableObject {
    @Published var currentPhoto: PhotoEntry?
    @Published var isProcessing = false
    
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
    
    func processPhoto(_ image: UIImage) async {
        isProcessing = true
        
        // Use Google Gemini for AI-powered image analysis
        let geminiAnalysis = await analyzeWithGemini(image)
        
        // Fallback to Vision framework if Gemini fails
        if let analysis = geminiAnalysis {
            currentPhoto = PhotoEntry(
                image: image,
                imageName: "captured_photo_\(Date().timeIntervalSince1970)",
                dateTaken: Date(),
                location: analysis.location,
                caption: analysis.caption,
                locationName: analysis.locationName,
                aiDescription: analysis.description,
                fact1: analysis.fact1,
                fact2: analysis.fact2,
                fact3: analysis.fact3
            )
        } else {
            // Fallback to local Vision analysis
            let visionAnalysis = await analyzeImageWithVision(image)
            currentPhoto = PhotoEntry(
                image: image,
                imageName: "captured_photo_\(Date().timeIntervalSince1970)",
                dateTaken: Date(),
                location: visionAnalysis.location,
                caption: visionAnalysis.caption,
                locationName: visionAnalysis.locationName,
                aiDescription: visionAnalysis.description,
                fact1: nil,
                fact2: nil,
                fact3: nil
            )
        }
        
        isProcessing = false
    }
    
    func reset() {
        currentPhoto = nil
        isProcessing = false
    }
    
    // MARK: - Google Gemini Vision API
    
    private func analyzeWithGemini(_ image: UIImage) async -> (location: String, locationName: String, caption: String, description: String, fact1: String, fact2: String, fact3: String)? {
        // Check if API key is set
        guard geminiAPIKey != "YOUR_GEMINI_API_KEY_HERE" && !geminiAPIKey.isEmpty else {
            print("⚠️ Gemini API key not set. Get your FREE key at: https://makersuite.google.com/app/apikey")
            return nil
        }
        
        print("🔍 Analyzing image with Gemini AI...")
        
        // Convert image to base64
        guard let imageData = image.jpegData(compressionQuality: 0.7) else {
            return nil
        }
        let base64Image = imageData.base64EncodedString()
        
        // Create detailed prompt for travel analysis
        let prompt = """
        You are an expert travel guide analyzing a photo. Provide a detailed analysis in JSON format with these exact fields:
        
        {
          "locationName": "The specific name of the landmark, monument, city, or natural feature (e.g., 'Eiffel Tower', 'Grand Canyon', 'Tokyo Tower')",
          "location": "Full location with city and country (e.g., 'Paris, France', 'Arizona, USA', 'Tokyo, Japan')",
          "caption": "A short 3-5 word description (e.g., 'Iconic iron tower', 'Majestic natural wonder')",
          "description": "A detailed 3-4 sentence description including: what this place is, its historical/cultural significance, interesting facts, and why it's worth visiting",
          "fact1": "First interesting historical or cultural fact (e.g., 'Built in 1889 for the World's Fair')",
          "fact2": "Second interesting fact about visitor experience or significance (e.g., 'Most visited paid monument in the world')",
          "fact3": "Third architectural or cultural fact (e.g., 'Named after engineer Gustave Eiffel')"
        }
        
        Be specific with landmark names and locations. Include the city AND country in the location field. Make facts concise but interesting.
        
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

