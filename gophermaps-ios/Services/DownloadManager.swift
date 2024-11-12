//
//  InstructionManager.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/2/24.
//

import Foundation


// Used to tell if a download failed because the device is offline, or some other reason
enum DownloadFailure: Error {
    case networkOffline
    case noInstructionsFound
    case manifestError(Error)
    case otherError(Error)
}

// Used to reflect instruction availability in the UI
enum DownloadStatus {
    case unavailable
    case missing
    case waiting
    case downloaded
    case failed(DownloadFailure)
}

// Used to reflect whether a file is up-to-date
enum FileCurrentness {
    case unknown
    case outdated
    case upToDate
}


actor DownloadManager {
    static let shared = DownloadManager()
    
    private let fileManager = FileManager.default
    private let instructionsDirectory: URL
    
    private let instructionsBaseURL: URL = .init(string: "https://raw.githubusercontent.com/ryan-roche/gophermaps-data/main/instructions")!
    private let manifestDownloadURL: URL = .init(string: "https://raw.githubusercontent.com/ryan-roche/gophermaps-data/main/manifest.json")!
    
    private var manifestDownload: Task<ManifestModel, Error>?
    private var activeDownloads: [URL: Task<Void, Error>] = [:]
    private(set) var instructionDownloadStatuses: [String: DownloadStatus] = [:]
    
    init() {
        // Find the app's documents directory
        let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        self.instructionsDirectory = documentsDirectory.appendingPathComponent("instructions")
        
        // Ensure the instructions directory exists
        if !fileManager.fileExists(atPath: instructionsDirectory.path) {
            try! fileManager.createDirectory(at: instructionsDirectory, withIntermediateDirectories: true)
        }
        
        // Start an attempt to download the manifest.json file
        Task {
            await attemptManifestDownload()
        }
    }
    
    /// Attempts to download the manifest.json file, storing the task in self.manifestDownload
    private func attemptManifestDownload() {
        manifestDownload = Task {
            let (data, response) = try await URLSession.shared.data(from: manifestDownloadURL)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw NSError(domain: "ManifestDownloadError",
                            code: 1,
                            userInfo: [NSLocalizedDescriptionKey: "Invalid HTTP response"])
            }
            
            let decoder = JSONDecoder()
            return try decoder.decode(ManifestModel.self, from: data)
        }
    }
    
    /// Awaits the current manifest download, retrying ONCE if it fails
    private func getManifest() async throws(DownloadFailure) -> ManifestModel {
        do {
            if let currentDownload = manifestDownload {
                do {
                    return try await currentDownload.value
                } catch {
                    attemptManifestDownload()
                }
            } else {
                // If there isn't an existing download, create a new one
                attemptManifestDownload()
            }
            
            // Make sure that the new task was successfully created
            guard let newDownload = manifestDownload else {
                throw NSError(domain: "ManifestDownloadError",
                              code: 2,
                              userInfo: [NSLocalizedDescriptionKey: "Manifest download failed"])
            }
            
            // Return the result of the new download, letting any error propagate up
            return try await newDownload.value
        } catch {
            throw DownloadFailure.manifestError(error)
        }
    }
    
    /// Attempts to retrieve the most recently created server message
    func getServerMessage() async throws -> ServerMessageModel? {
        let manifest = try await getManifest()
        let messages = manifest.serverMessages
        return messages.min(by: { $0.startDateObject! < $1.startDateObject! })
    }
    
    /// Downloads the instructions for given directories
    /// - Parameter dirs: List of instruction directory name strings (i.e. "startID-endID")
    func downloadInstructions(from dir: String) async throws(DownloadFailure) {
        
        let manifest = try await getManifest()

        // Assemble a list of URLs from the manifest.json data
        if let files = manifest.instructions[dir]?.files {
            
            print("Downloading files for \(dir):")
            for file in files {
                print("• \(file)")
            }
            
            // Ensure destination directory for instructions exists
            let destinationDirectory = instructionsDirectory.appendingPathComponent(dir)
            do {
                if !fileManager.fileExists(atPath: destinationDirectory.path) {
                    try fileManager.createDirectory(at: instructionsDirectory, withIntermediateDirectories: true)
                    print("Created directory for \(dir)!")
                }
            } catch {
                print("Failed to create directory for \(dir)'s instruction files: \(error)")
                throw DownloadFailure.otherError(error)
            }
            
            // Append filenames to create URLS
            let downloadURLs = files.map { filename in
                instructionsBaseURL
                    .appendingPathComponent(dir)
                    .appendingPathComponent(filename)
            }
            let destinationURLs = files.map { filename in
                destinationDirectory
                    .appendingPathComponent(filename)
            }
            let urlPairs = zip(downloadURLs, destinationURLs).map {
                (source: $0, destination: $1)
            }
            
            instructionDownloadStatuses[dir] = .waiting
            
            // Await call to downloadFiles and update status accordingly
            do {
                try await downloadFiles(from: urlPairs)
                instructionDownloadStatuses[dir] = .downloaded
            }
            catch {
                // Update status to reflect failure, then propogate error
                instructionDownloadStatuses[dir] = .failed(.otherError(error))
                // TODO: add logic to determine if network was offline
                throw DownloadFailure.otherError(error)
            }
            
        } else {
            throw DownloadFailure.noInstructionsFound
        }
    }
    
    /// Returns the status for a given directory of instructions
    func getInstructionStatus(for dir: String) async throws(DownloadFailure) -> DownloadStatus {
        let manifest = try await getManifest()
        if !manifest.instructions.keys.contains(dir) {
            return .unavailable
        }
        
        if !instructionDownloadStatuses.keys.contains(dir) {
            instructionDownloadStatuses[dir] = .missing
        }
        return instructionDownloadStatuses[dir]!
    }
    
    /// Attempts to delete all downloaded instruction data
    func clearDownloadedInstructions() async throws {
        let fileManager = FileManager.default
        let contents = try fileManager.contentsOfDirectory(at: instructionsDirectory, includingPropertiesForKeys: nil)
        for fileUrl in contents {
            try fileManager.removeItem(at: fileUrl)
        }
        instructionDownloadStatuses = [:]
    }
    
    /// Asynchronously downloads files from a list of URLs
    /// - Parameter urls: URLs to the files to be downloaded
    private func downloadFiles(from urls: [(source: URL, destination: URL)]) async throws {
        try await withThrowingTaskGroup(of: Void.self) { group in
            for (source, destination) in urls {
                group.addTask {
                    try await self.downloadFile(from: source, to: destination)
                }
            }
            try await group.waitForAll()
        }
    }
    
    private func downloadFile(from url: URL, to destinationURL: URL) async throws {

        // Then, check if there's already an ongoing download for this URL
        if let existingTask = activeDownloads[url] {
            // Wait for the ongoing download to finish
            return try await existingTask.value
        }

        // Otherwise, start a new download task for the file
        let downloadTask = Task<Void, Error> {
            do {
                // Create directory if needed
                try FileManager.default.createDirectory(
                    at: destinationURL.deletingLastPathComponent(),
                    withIntermediateDirectories: true
                )
                
                // Download file directly to temporary location
                let (tempURL, response) = try await URLSession.shared.download(from: url)
                
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw NSError(domain: "DownloadError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to download file: \(url.absoluteString)"])
                }
                
                // Move the temporary file to the destination
                if FileManager.default.fileExists(atPath: destinationURL.path) {
                    try FileManager.default.removeItem(at: destinationURL)
                }
                try FileManager.default.moveItem(at: tempURL, to: destinationURL)
                
                print("✓ Successfully downloaded file to \(destinationURL.path)")
            } catch {
                print("downloadFile failed for \(url.lastPathComponent): \(error.localizedDescription)")
                throw error
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
