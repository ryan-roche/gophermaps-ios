//
//  InstructionManager.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/2/24.
//

import Foundation

actor InstructionsManager {
    static let shared = InstructionsManager()
    
    private let fileManager = FileManager.default
    private let instructionsDirectory: URL
    private var activeDownloads: [URL: Task<Void, Error>] = [:]
    
    init() {
        // Destination Directory
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.instructionsDirectory = documentsDirectory.appendingPathComponent("instructions")
        
        // Ensure the destination directory exists
        if !fileManager.fileExists(atPath: instructionsDirectory.path) {
            try! fileManager.createDirectory(at: instructionsDirectory, withIntermediateDirectories: true)
        }
    }
    
    func downloadFiles(from urls: [URL]) async {
        await withTaskGroup(of: Void.self) { group in
            for url in urls {
                group.addTask {
                    do {
                        try await self.downloadFile(from: url)
                    } catch {
                        print("Failed to download file at \(url.absoluteString): \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func downloadFile(from url: URL) async throws {
        
        // First, check if the file has already been downloaded
        let lastPathComponent = url.lastPathComponent   // "instructions.md, img1, etc."
        let secondLastPathComponent = url.deletingLastPathComponent().lastPathComponent // "start-end"
        
        let destinationDirectory = instructionsDirectory.appendingPathComponent(secondLastPathComponent)
        let destinationURL = destinationDirectory.appendingPathComponent(lastPathComponent)
        
        if fileManager.fileExists(atPath: destinationURL.path) {
            print("Requested file \(destinationDirectory.absoluteString) already exists. Skipping...")
            return
        }

        // Then, check if there's already an ongoing download for this URL
        if let existingTask = activeDownloads[url] {
            // Wait for the ongoing download to finish
            return try await existingTask.value
        }

        // Otherwise, start a new download task for the file
        let downloadTask = Task<Void, Error> {
            do {
                // Download data from the URL using URLSession
                let (data, response) = try await URLSession.shared.data(from: url)

                // Check the HTTP response
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: "DownloadError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to download file: \(url.absoluteString)"])
                }

                // Write the data to the destination URL
                try data.write(to: destinationURL)
                print("Successfully downloaded file to \(destinationURL.path)")
            } catch {
                print("Download failed: \(error.localizedDescription)")
                throw error // Propagate the error
            }
        }

        // Store the active download task
        activeDownloads[url] = downloadTask
        
        // Ensure to remove the task from active downloads after completion
        defer { activeDownloads.removeValue(forKey: url) }

        // Await the completion of the download task
        try await downloadTask.value
    }
    
}
