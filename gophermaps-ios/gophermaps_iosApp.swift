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

// Singleton API Client (shonal would be so proud...)
//#if DEBUG
//let apiClient = MockAPIClient()
//#else
let apiClient = Client(
    serverURL: try! Servers.server1(),
    transport: URLSessionTransport()
)
//#endif

let thumbnailBaseURL = "https://raw.githubusercontent.com/ryan-roche/gophermaps-data/main/thumbnails"
let instructionBaseURL = "https://raw.githubusercontent.com/ryan-roche/gophermaps-data/main/instructions"

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
        }.modelContainer(for: SavedRoute.self)
    }
}
