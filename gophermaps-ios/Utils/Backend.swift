//
//  BackendInterface.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/12/24.
//

import SwiftUI

private struct SelectedAPIHandler: EnvironmentKey {
    static let defaultValue: APIHandler = BackendStubs()
}

extension EnvironmentValues {
    var apiHandler: APIHandler {
        get { self[SelectedAPIHandler.self] }
        set { self[SelectedAPIHandler.self] = newValue }
    }
}

protocol APIHandler {
    static func pingServer(ip: String) async throws -> Bool
    static func getAreas() async throws -> [String]
    static func getBuildings(area: String) async throws -> [BuildingEntry]
    static func getDestinations(start: BuildingEntry) async throws -> [BuildingEntry]
    static func getRoute(start: BuildingEntry, end: BuildingEntry) async throws -> [any PathStep]
    static func downloadRouteData(route: [any PathStep]) async -> Bool
    static func downloadThumbnails(buildings: [BuildingEntry]) async -> Bool
}

@Observable final class Backend: APIHandler {
    static func pingServer(ip: String) async throws -> Bool {
        // Build the URL from the IP address
        guard let url = URL(string: "http://\(ip)") else {
            throw URLError(.badURL) // Throw error if URL construction fails
        }
        
        // Build and perform the URLRequest
        let request = URLRequest(url: url)
        let (_, response) = try await URLSession.shared.data(for: request)
        
        // Check for a valid response
        guard let httpResponse = response as? HTTPURLResponse else {
            throw URLError(.badServerResponse) // Throw error if server response is invalid
        }
        
        // Check the status code
        return (200..<300 ~= httpResponse.statusCode)
    }
    
    // Gets a string array of the areas available in the database
    static func getAreas() async throws -> [String] {
        // Build the URL
        guard let url = URL(string: "http://\(UserDefaults.standard.string(forKey: "serverAddress") ?? "0.0.0.0"):8080/areas") else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        do {
            let decodedResponse = try JSONDecoder().decode([String].self, from: data)
            return decodedResponse
        } catch {
            print("Error decoding JSON response.")
            return ["Request failed"]
        }
    }
    
    // Gets a string array of the names of the buildings in an area
    static func getBuildings(area: String) async throws -> [BuildingEntry] {
        // Build the URL from the server IP
        guard let url = URL(string: "http://\(UserDefaults.standard.string(forKey: "serverAddress") ?? "0.0.0.0"):8080/buildings/\(area)") else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        
        // Decode the response from a JSON String array into a Swift String array
        do {
            let decodedResponse = try JSONDecoder().decode([BuildingEntry].self, from: data)
            return decodedResponse
        } catch {
            print("Error decoding JSON response: \(error)")
            return []
        }
    }
    
    // Gets an array of buildingEntry objects representing the buildings reachable from a given building entry
    static func getDestinations(start: BuildingEntry) async throws -> [BuildingEntry] {
        // Build the API request URL using the server IP
        guard let url = URL(string: "http://\(UserDefaults.standard.string(forKey: "serverAddress") ?? "0.0.0.0"):8080/destinations/\(start.navID)") else {
            throw URLError(.badURL)
        }
        
        print(url)
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
    
        // Decode the response from a JSON array into a Swift array of BuildingEntry objects
        do {
            print(String(data:data, encoding:.utf8) ?? "Data is empty")
            let decodedResponse = try JSONDecoder().decode([BuildingEntry].self, from: data)
            return decodedResponse
        } catch {
            print("Error decoding JSON response: \(error)")
            return []
        }
    }
    
    static func getRoute(start: BuildingEntry, end: BuildingEntry) async throws -> [any PathStep] {
        guard let url = URL(string: "http://\(UserDefaults.standard.string(forKey: "serverAddress") ?? "0.0.0.0"):8080/routes/\(start.navID)-\(end.navID)") else {
            throw URLError(.badURL)
        }
        
        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)
        print(String(data:data, encoding:.utf8) ?? "Data is empty")
        
        // Decode the response from a JSON array into a Swift array of PathStep objects
        do {
            let rawDictionaries = try JSONSerialization.jsonObject(with: data, options: []) as! [[String: Any]]
            
            let decodedResponse = try rawDictionaries.map { (decodedDictionary: [String: Any]) -> PathStep in
                if let buildingEntry = try? JSONDecoder().decode(BuildingEntry.self, from: JSONSerialization.data(withJSONObject: decodedDictionary)),
                   buildingEntry is BuildingEntry {
                    return buildingEntry
                } else if let graphNode = try? JSONDecoder().decode(GraphNode.self, from: JSONSerialization.data(withJSONObject: decodedDictionary)), graphNode is GraphNode {
                    return graphNode
                } else {
                    throw DecodingError.dataCorrupted(DecodingError.Context(codingPath: [], debugDescription: "Unable to decode object as BuildingEntry or GraphNode"))
                }
            }
            
            return decodedResponse
        } catch {
            print("Error decoding JSON response: \(error)")
            return []
        }
    }
    
    // Asynchronously download all of the instruction data for the given route
    // TODO: Implement this
    static func downloadRouteData(route: [PathStep]) async -> Bool {
        print("Downloading Route Data")
        do { 
            try await Task.sleep(nanoseconds: 2_000_000_000)
            print("Download Complete!")
            return true
        }
        catch { 
            print("Download Failed")
            return false
        }
    }
    
    // Asynchronously download the thumbnail images for the buildings in the given list
    // TODO: Implement this
    static func downloadThumbnails(buildings: [BuildingEntry]) async -> Bool {
        // DownloadSuccessCount = 0
        // Iterate over the building list. For each:
            // Build URL for the image file
            // Download the image file to documents/thumbnails
            // Increment downloadSuccessCount appropriately
        
        // Return true if all downloads were successful
        return true
    }
}

@Observable final class BackendStubs: APIHandler {
    static func pingServer(ip: String) async throws -> Bool {
        try await Task.sleep(nanoseconds: 500_000_000)
        return true
    }
    
    static func getAreas() async throws -> [String] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return ["TestAreas", "EastBank", "WestBank", "WeastBank"]
    }
    
    static func getBuildings(area: String) async throws -> [BuildingEntry] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return previewBuildings
    }
    
    static func getDestinations(start: BuildingEntry) async throws -> [BuildingEntry] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        let destinations = previewBuildings
        return destinations.filter { $0 != start }
    }
    
    static func getRoute(start: BuildingEntry, end: BuildingEntry) async throws -> [any PathStep] {
        try await Task.sleep(nanoseconds: 1_000_000_000)
        return previewNavRoute
    }
    
    static func downloadRouteData(route: [PathStep]) async -> Bool {
        print("Copying preview data from bundle to documents directory")
        
        // Instruction markdown file
        guard let sourceURL = Bundle.main.url(forResource: "test-instructions", withExtension: "md") else {
            print("Failed to find instructions in bundle")
            return false
        }
        
        do {
            // Generate URL to documents directory
            let docsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print("docsURL: \(docsURL)")
        
            
            // MARK: tb1a-tb2a
            // Generate URL for edge directory
            var dirURL = docsURL.appendingPathComponent("tb1a-tb2a")
            
            // Delete edge directory if it already exists
            if FileManager.default.fileExists(atPath: dirURL.path) {
                try FileManager.default.removeItem(at: dirURL)
                print("Removed existing directory")
            }
            
            // Create directory for edge
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: false)
            print("Created edge directory")
            
            // Copy files to edge directory
            print("Copying files for tb1a-tb2a")
            
            // instructions.md
            guard let sourceURL = Bundle.main.url(forResource: "tb1a-tb2a", withExtension: "md") else {
                print("Failed to copy tb1a-tb2a/instructions.md")
                return false
            }
            var destinationURL = docsURL.appendingPathComponent("tb1a-tb2a/instructions.md")
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            // test-instructions-1.png
            guard let sourceURL = Bundle.main.url(forResource: "test-instructions-1", withExtension: "png") else {
                print("Failed to copy tb1a-tb2a/test-instructions-1.png")
                return false
            }
            destinationURL = docsURL.appendingPathComponent("tb1a-tb2a/test-instructions-1.png")
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            
            // MARK: tb2a-tb3a
            // Generate URL for edge directory
            dirURL = docsURL.appendingPathComponent("tb2a-tb3a")
            
            // Delete edge directory if already present
            if FileManager.default.fileExists(atPath: dirURL.path) {
                try FileManager.default.removeItem(at: dirURL)
                print("Removed existing directory")
            }
            
            // Create directory for edge
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: false)
            print("Created edge directory")
            
            // Copy files to edge directory
            print("Copying files for tb2a-tb3a")
            
            // instructions.md
            guard let sourceURL = Bundle.main.url(forResource: "tb2a-tb3a", withExtension: "md") else {
                print("Failed to copy tb2a-tb3a/instructions.md")
                return false
            }
            destinationURL = docsURL.appendingPathComponent("tb2a-tb3a/instructions.md")
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            
            //test-instructions-2.png
            guard let sourceURL = Bundle.main.url(forResource: "test-instructions-2", withExtension: "png") else {
                print("Failed to copy tb2a-tb3a/test-instructions-2.png")
                return false
            }
            destinationURL = docsURL.appendingPathComponent("tb2a-tb3a/test-instructions-2.png")
            try FileManager.default.copyItem(at: sourceURL, to:destinationURL)
            
        } catch {
            print("Failed to copy instructions!")
            print(error)
            return false
        }
        
        return true
    }
    
    static func downloadThumbnails(buildings: [BuildingEntry]) async -> Bool {
        // Copy preview thumbnails from bundle to documents
        var successfulCopies = 0
        
        // Create thumbnails directory if it doesn't exist
        
        
        // Loop through buildings, copying the corresponding thumbnails
        
        
        return successfulCopies == buildings.count
    }
}
