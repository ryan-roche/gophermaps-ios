//
//  gophermaps_iosApp.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/24/24.
//

import SwiftUI

@main
struct gophermaps_iosApp: App {
    // Code to run on startup
    init() {
        UserDefaults.standard.register(defaults: [
            "goButtonOnLeft" : true,
            "serverAddress" : "128.101.131.206"
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
