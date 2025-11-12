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
    
    private func analyzeImageWithVision(_ image: UIImage) async -> (location: String, locationName: String, caption: String, description: String) {
        guard let cgImage = image.cgImage else {
            return getDefaultAnalysis()
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        var detectedScenes: [String] = []
        var confidence: Float = 0.0
        
        // Scene Classification Request
        let sceneRequest = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else { return }
            
            detectedScenes = observations.prefix(5).map { $0.identifier }
            
            if let topObservation = observations.first {
                confidence = topObservation.confidence
            }
        }
        
        // Text Detection Request
        var detectedText: [String] = []
        let textRequest = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            detectedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.prefix(10).map { $0 }
        }
        textRequest.recognitionLevel = .accurate
        
        // Perform requests
        do {
            try requestHandler.perform([sceneRequest, textRequest])
        } catch {
            print("Vision request failed: \(error)")
            return getDefaultAnalysis()
        }
        
        return generateAnalysisFromDetections(
            scenes: detectedScenes,
            text: detectedText,
            confidence: confidence
        )
    }
    
    private func generateAnalysisFromDetections(
        scenes: [String],
        text: [String],
        confidence: Float
    ) -> (location: String, locationName: String, caption: String, description: String) {
        
        // Check for landmarks in text
        if let landmark = detectLandmarkFromText(text) {
            return getLandmarkInfo(landmark)
        }
        
        // Analyze scenes
        let sceneType = categorizeScene(scenes)
        
        var locationName = sceneType.name
        var location = sceneType.location
        var caption = sceneType.caption
        var description = sceneType.description
        
        // Add detected text if meaningful
        let meaningfulText = text.filter { $0.count > 2 && $0.count < 50 }
        if !meaningfulText.isEmpty {
            description += "\n\nDetected text: " + meaningfulText.prefix(5).joined(separator: ", ")
        }
        
        return (location: location, locationName: locationName, caption: caption, description: description)
    }
    
    private func categorizeScene(_ scenes: [String]) -> (name: String, location: String, caption: String, description: String) {
        let sceneLower = scenes.joined(separator: " ").lowercased()
        
        if sceneLower.contains("tower") || sceneLower.contains("monument") {
            return (
                name: "Historic Monument",
                location: "Historic Site",
                caption: "Architectural landmark",
                description: "This image shows a prominent monument or tower structure with historical significance."
            )
        } else if sceneLower.contains("building") || sceneLower.contains("architecture") {
            return (
                name: "Architectural Structure",
                location: "Urban Area",
                caption: "Notable architecture",
                description: "This image captures significant architectural design and construction."
            )
        } else if sceneLower.contains("mountain") || sceneLower.contains("landscape") {
            return (
                name: "Mountain Landscape",
                location: "Natural Environment",
                caption: "Scenic mountain view",
                description: "This image showcases beautiful natural mountain scenery."
            )
        } else if sceneLower.contains("beach") || sceneLower.contains("coast") || sceneLower.contains("ocean") {
            return (
                name: "Coastal Area",
                location: "Waterfront",
                caption: "Coastal scenery",
                description: "This image captures stunning coastal or beach landscape."
            )
        } else if sceneLower.contains("city") || sceneLower.contains("urban") {
            return (
                name: "Urban Scene",
                location: "City Center",
                caption: "City landscape",
                description: "This image shows an urban environment with city features."
            )
        } else {
            return (
                name: scenes.first?.capitalized ?? "Interesting Location",
                location: "Unknown",
                caption: "Scenic location",
                description: "This image captures an interesting location worth documenting."
            )
        }
    }
    
    private func detectLandmarkFromText(_ text: [String]) -> String? {
        let landmarks = [
            "eiffel": "Eiffel Tower",
            "tower": "Historic Tower",
            "colosseum": "Colosseum",
            "parthenon": "Parthenon",
            "big ben": "Big Ben",
            "statue of liberty": "Statue of Liberty",
            "taj mahal": "Taj Mahal",
            "notre dame": "Notre-Dame",
            "louvre": "Louvre Museum",
            "acropolis": "Acropolis",
            "tower bridge": "Tower Bridge",
            "brandenburg gate": "Brandenburg Gate",
            "sagrada familia": "Sagrada Familia"
        ]
        
        for textLine in text {
            let lowercased = textLine.lowercased()
            for (key, value) in landmarks {
                if lowercased.contains(key) {
                    return value
                }
            }
        }
        
        return nil
    }
    
    private func getLandmarkInfo(_ name: String) -> (location: String, locationName: String, caption: String, description: String) {
        let landmarks: [String: (location: String, caption: String, description: String)] = [
            "Eiffel Tower": (
                "Paris, France",
                "Iconic iron tower",
                "The Eiffel Tower is a 330-meter wrought-iron lattice tower, built in 1889 as the entrance arch to the World's Fair."
            ),
            "Colosseum": (
                "Rome, Italy",
                "Ancient amphitheater",
                "The Colosseum is an ancient amphitheater built in 70-80 AD, used for gladiatorial contests and public spectacles."
            ),
            "Parthenon": (
                "Athens, Greece",
                "Ancient Greek temple",
                "The Parthenon is a former temple dedicated to the goddess Athena, built in 447 BC."
            )
        ]
        
        if let info = landmarks[name] {
            return (
                location: info.location,
                locationName: name,
                caption: info.caption,
                description: info.description
            )
        }
        
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
    
    private func analyzeImageWithVision(_ image: UIImage) async -> (location: String, locationName: String, caption: String, description: String) {
        guard let cgImage = image.cgImage else {
            return getDefaultAnalysis()
        }
        
        // Create Vision request handler
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        
        var detectedScenes: [String] = []
        var detectedObjects: [String] = []
        var confidence: Float = 0.0
        
        // Scene Classification Request
        let sceneRequest = VNClassifyImageRequest { request, error in
            guard let observations = request.results as? [VNClassificationObservation] else { return }
            
            // Get top 5 classifications
            detectedScenes = observations.prefix(5).map { observation in
                observation.identifier
            }
            
            if let topObservation = observations.first {
                confidence = topObservation.confidence
            }
        }
        
        // Object Recognition Request
        let objectRequest = VNRecognizeAnimalsRequest { request, error in
            guard let observations = request.results as? [VNRecognizedObjectObservation] else { return }
            
            detectedObjects = observations.prefix(3).compactMap { observation in
                observation.labels.first?.identifier
            }
        }
        
        // Text Detection Request (for signs, plaques, etc.)
        var detectedText: [String] = []
        let textRequest = VNRecognizeTextRequest { request, error in
            guard let observations = request.results as? [VNRecognizedTextObservation] else { return }
            
            detectedText = observations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.prefix(5).map { $0 }
        }
        textRequest.recognitionLevel = .accurate
        
        // Perform requests
        do {
            try requestHandler.perform([sceneRequest, objectRequest, textRequest])
        } catch {
            print("Vision request failed: \(error)")
            return getDefaultAnalysis()
        }
        
        // Generate analysis based on detected content
        return generateAnalysisFromDetections(
            scenes: detectedScenes,
            objects: detectedObjects,
            text: detectedText,
            confidence: confidence
        )
    }
    
    // MARK: - Analysis Generation
    
    private func generateAnalysisFromDetections(
        scenes: [String],
        objects: [String],
        text: [String],
        confidence: Float
    ) -> (location: String, locationName: String, caption: String, description: String) {
        
        // First check for famous landmarks in detected text
        if let landmark = detectLandmarkFromText(text) {
            return getLandmarkDetails(landmark)
        }
        
        // Analyze scene types to determine location type
        let isArchitecture = scenes.contains(where: { $0.contains("building") || $0.contains("architecture") || $0.contains("monument") || $0.contains("tower") })
        let isNature = scenes.contains(where: { $0.contains("mountain") || $0.contains("landscape") || $0.contains("forest") || $0.contains("beach") || $0.contains("valley") })
        let isUrban = scenes.contains(where: { $0.contains("city") || $0.contains("street") || $0.contains("urban") })
        let isHistorical = scenes.contains(where: { $0.contains("historical") || $0.contains("castle") || $0.contains("temple") || $0.contains("palace") })
        let isReligious = scenes.contains(where: { $0.contains("church") || $0.contains("cathedral") || $0.contains("mosque") || $0.contains("temple") })
        
        // Generate contextual description
        var locationName = "Unknown Location"
        var location = "Location not determined"
        var caption = "Captured moment"
        var description = ""
        
        if isArchitecture || isHistorical {
            locationName = "Historic Building"
            location = "Historic Site"
            caption = "Architectural marvel captured"
            description = "This image showcases a significant architectural structure with historical importance. "
            
            if scenes.contains(where: { $0.contains("tower") }) {
                description += "The prominent tower structure suggests this could be an iconic landmark or bell tower. "
                locationName = "Historic Tower"
            }
            if scenes.contains(where: { $0.contains("gothic") || $0.contains("classical") || $0.contains("baroque") }) {
                description += "The architectural style displays classical or period design elements characteristic of European monuments. "
            }
            if scenes.contains(where: { $0.contains("amphitheater") || $0.contains("arena") }) {
                description += "This appears to be an ancient amphitheater or arena, likely used for public gatherings and entertainment. "
                locationName = "Ancient Amphitheater"
            }
            
            description += "Historical structures like this represent significant periods in architectural history and often serve as major tourist destinations."
            
        } else if isReligious {
            locationName = "Religious Monument"
            location = "Sacred Site"
            caption = "Sacred architecture captured"
            description = "This image shows a religious building with spiritual and cultural significance. "
            
            if scenes.contains(where: { $0.contains("cathedral") || $0.contains("church") }) {
                description += "The cathedral architecture features traditional Christian design elements. "
                locationName = "Historic Cathedral"
            }
            
            description += "Religious sites like this are often architectural masterpieces that attract pilgrims and tourists alike."
            
        } else if isNature {
            locationName = "Natural Landscape"
            location = "Natural Environment"
            caption = "Beautiful natural scenery"
            description = "This image captures stunning natural scenery. "
            
            if scenes.contains(where: { $0.contains("mountain") }) {
                description += "The majestic mountain landscape provides dramatic views and outdoor recreation opportunities. "
                locationName = "Mountain Vista"
            }
            if scenes.contains(where: { $0.contains("water") || $0.contains("ocean") || $0.contains("beach") || $0.contains("sea") }) {
                description += "Coastal or waterfront features add to the scenic beauty and natural appeal. "
                locationName = "Coastal Scenery"
            }
            if scenes.contains(where: { $0.contains("forest") }) {
                description += "The forest setting offers peaceful natural surroundings and biodiversity. "
                locationName = "Forest Landscape"
            }
            
            description += "Natural environments like this provide perfect opportunities to connect with nature and enjoy outdoor activities."
            
        } else if isUrban {
            locationName = "Urban Scene"
            location = "City Environment"
            caption = "City life captured"
            description = "This image captures a vibrant urban environment. "
            
            if scenes.contains(where: { $0.contains("square") || $0.contains("plaza") }) {
                description += "Public squares are gathering places that often showcase important monuments and city life. "
                locationName = "City Square"
            }
            
            description += "Urban settings offer diverse cultural experiences, modern architecture, and bustling activity."
            
        } else {
            // Use most confident scene classification
            if let topScene = scenes.first {
                locationName = topScene.replacingOccurrences(of: "_", with: " ").capitalized
            }
            caption = "Interesting scene captured"
            description = "This image captures a noteworthy location. "
            description += "The scene suggests visual or cultural significance worth documenting and exploring further."
        }
        
        // Add confidence and detected info
        if confidence > 0.8 {
            description += "\n\n✓ High confidence detection based on visual analysis."
        }
        
        return (location: location, locationName: locationName, caption: caption, description: description)
    }
    
    // Get detailed information for known landmarks
    private func getLandmarkDetails(_ landmarkName: String) -> (location: String, locationName: String, caption: String, description: String) {
        switch landmarkName {
        case "Eiffel Tower":
            return (
                location: "Paris, France",
                locationName: "Eiffel Tower",
                caption: "Iconic iron tower in the heart of Paris",
                description: "The Eiffel Tower, completed in 1889, stands as a global cultural icon of France. This wrought-iron lattice tower reaches 330 meters high and offers breathtaking panoramic views of Paris from three observation levels. Originally built for the 1889 World's Fair, it has become one of the most recognizable structures in the world, attracting millions of visitors annually."
            )
            
        case "Colosseum":
            return (
                location: "Rome, Italy",
                locationName: "Colosseum",
                caption: "Ancient Roman amphitheater",
                description: "The Colosseum, built between 70-80 AD, is an oval amphitheater in central Rome. It could hold 50,000 to 80,000 spectators and was used for gladiatorial contests, animal hunts, and public spectacles. Despite earthquakes and stone-robbers, it remains an iconic symbol of Imperial Rome and is listed as one of the New Seven Wonders of the World."
            )
            
        case "Parthenon":
            return (
                location: "Athens, Greece",
                locationName: "Parthenon",
                caption: "Ancient temple dedicated to Athena",
                description: "The Parthenon is a former temple on the Athenian Acropolis, dedicated to the goddess Athena. Construction began in 447 BC when Athens was at its peak. It's regarded as an enduring symbol of Ancient Greece, Athenian democracy, and Western civilization, with decorative sculptures considered among the finest examples of Greek art."
            )
            
        case "Big Ben":
            return (
                location: "London, United Kingdom",
                locationName: "Big Ben",
                caption: "Iconic clock tower of London",
                description: "Big Ben is the nickname for the Great Bell of the clock at the Palace of Westminster. The tower was completed in 1859 and has become one of London's most iconic landmarks. The clock is renowned for its reliability and the distinctive chime of its bells, which have become a symbol of British culture worldwide."
            )
            
        case "Statue of Liberty":
            return (
                location: "New York, USA",
                locationName: "Statue of Liberty",
                caption: "Symbol of freedom and democracy",
                description: "The Statue of Liberty, a gift from France to the United States, was dedicated in 1886. Standing at 305 feet tall, Lady Liberty has welcomed millions of immigrants arriving by sea. The statue has become a universal symbol of freedom and democracy, and is one of America's most recognizable icons."
            )
            
        case "Taj Mahal":
            return (
                location: "Agra, India",
                locationName: "Taj Mahal",
                caption: "Ivory-white marble mausoleum",
                description: "The Taj Mahal was commissioned by Mughal emperor Shah Jahan in 1632 as a tomb for his wife Mumtaz Mahal. This ivory-white marble mausoleum is considered the finest example of Mughal architecture, combining elements from Islamic, Persian, Ottoman Turkish, and Indian styles. It's a UNESCO World Heritage Site and attracts millions of visitors yearly."
            )
            
        case "Notre-Dame":
            return (
                location: "Paris, France",
                locationName: "Notre-Dame Cathedral",
                caption: "Gothic architectural masterpiece",
                description: "Notre-Dame de Paris is a medieval Catholic cathedral built between 1163 and 1345. It's considered one of the finest examples of French Gothic architecture, featuring innovative flying buttresses, stunning rose windows, and intricate sculptures. The cathedral has played a significant role in French history and culture for over 850 years."
            )
            
        case "Louvre Museum":
            return (
                location: "Paris, France",
                locationName: "Louvre Museum",
                caption: "World's largest art museum",
                description: "The Louvre is the world's most-visited museum and a historic landmark in Paris. Originally a royal palace, it opened as a museum in 1793. The iconic glass pyramid entrance was added in 1989. Housing over 38,000 objects, including the Mona Lisa and Venus de Milo, it spans human history from ancient civilizations to the 19th century."
            )
            
        case "Acropolis":
            return (
                location: "Athens, Greece",
                locationName: "Acropolis of Athens",
                caption: "Ancient citadel above Athens",
                description: "The Acropolis of Athens is an ancient citadel located on a rocky outcrop above the city. It contains the remains of several ancient buildings of great architectural and historic significance, including the Parthenon. Built in the 5th century BC, it represents the pinnacle of Classical Greek art and architecture."
            )
            
        default:
            return (
                location: "Unknown Location",
                locationName: landmarkName,
                caption: "Landmark detected",
                description: "This appears to be \(landmarkName), a notable landmark. The location has historical or cultural significance worth documenting and exploring."
            )
        }
    }
    
    // Detect famous landmarks from text
    private func detectLandmarkFromText(_ text: [String]) -> String? {
        let landmarks = [
            "eiffel": "Eiffel Tower",
            "tower": "Historic Tower",
            "colosseum": "Colosseum",
            "parthenon": "Parthenon",
            "big ben": "Big Ben",
            "statue of liberty": "Statue of Liberty",
            "taj mahal": "Taj Mahal",
            "notre dame": "Notre-Dame",
            "louvre": "Louvre Museum",
            "acropolis": "Acropolis"
        ]
        
        for textLine in text {
            let lowercased = textLine.lowercased()
            for (key, value) in landmarks {
                if lowercased.contains(key) {
                    return value
                }
            }
        }
        
        return nil
    }
    
    // Fallback analysis
    private func getDefaultAnalysis() -> (location: String, locationName: String, caption: String, description: String) {
        return (
            location: "Unknown Location",
            locationName: "Captured Scene",
            caption: "Moment captured",
            description: "This image has been captured and is ready for your review. The Vision framework was unable to provide detailed analysis, but the image has been successfully processed and saved."
        )
    }
