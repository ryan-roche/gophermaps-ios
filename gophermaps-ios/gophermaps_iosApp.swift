//
//  gophermaps_iosApp.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//

import SwiftUI
import SwiftData
import OpenAPIRuntime
import OpenAPIURLSession

// Instantiate generated API client object
#if DEBUG
@MainActor var apiClient = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
#else
let apiClient = Client(serverURL: try! Servers.server1(), transport: URLSessionTransport())
#endif

// Get baseURL values from baseURLs.plist
let baseURLConfig: [String: String] = {
    guard let path = Bundle.main.path(forResource: "baseURLs", ofType: "plist"),
          let dict = NSDictionary(contentsOfFile: path) as? [String: String] else {
        fatalError("Failed to load baseURLs.plist")
    }
    return dict
}()
let thumbnailBaseURL: String = {
    guard let url = baseURLConfig["ThumbnailBaseURL"] else {
        fatalError("ThumbnailBaseURL not found in baseURLs.plist")
    }
    return url
}()
let instructionBaseURL: String = {
    guard let url = baseURLConfig["InstructionBaseURL"] else {
        fatalError("InstructionBaseURL not found in baseURLs.plist")
    }
    return url
}()

enum apiCallState {
    case idle
    case loading
    case done
    case failed // TODO: add error reason parameter
    case offline
}

@main
struct gophermaps_iosApp: App {
    init() {
        // Initialize the DownloadManager
        _ = DownloadManager.shared
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: SavedRoute.self)
    }
}
