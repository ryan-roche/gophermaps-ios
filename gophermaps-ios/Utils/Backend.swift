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
    // TODO: Decode JSON into buildingEntry Swift objects
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
            let docsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            print("docsURL: \(docsURL)")
            // Create directory for route
            let dirURL = docsURL.appendingPathComponent("kh1a-th1a")
            try FileManager.default.createDirectory(at: dirURL, withIntermediateDirectories: false)
            print("Created route directory")
            
            // Copy files to route directory
            let destinationURL = docsURL.appendingPathComponent("kh1a-th1a/instructions.md")
            try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
            print("Copied instructions to \(destinationURL)")
        } catch {
            print("Failed to copy instructions")
            return false
        }
        
        // Images for instructions
        for i in 1...2 {
            print("Copying image \(i) to documents")
            
            guard let sourceURL = Bundle.main.url(forResource: "test-instructions-\(i)", withExtension: "png") else {
                print("Failed to find image \(i) in bundle")
                return false
            }
            
            do {
                let docsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
                print("docsURL: \(docsURL)")
                let destinationURL = docsURL.appendingPathComponent("kh1a-th1a/test-instructions-\(i).png")
                try FileManager.default.copyItem(at: sourceURL, to: destinationURL)
                print("Copied image \(i) to documents")
            } catch {
                print("Failed to copy image \(i)")
                return false
            }
        }
        
        return true
    }
}
