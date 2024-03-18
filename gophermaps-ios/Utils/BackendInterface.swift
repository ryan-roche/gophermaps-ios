//
//  BackendInterface.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/12/24.
//

import SwiftUI

@Observable class Backend {
    // Asynchronously download all of the instruction data for the given route
    static func downloadRouteData(route: [GraphNode]) async -> Bool {
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
