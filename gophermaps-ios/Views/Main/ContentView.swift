//
//  ContentView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/24/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showSettings = false
    
    var body: some View {
        NavigationStack {
            StartingPointSelect(startingPoints: previewBuildings)
                .toolbar {
                    Button {
                        showSettings.toggle()
                    } label: {
                        Image(systemName:"gear")
                    }
                }
                .sheet(isPresented: $showSettings, content: {
                    NavigationStack {
                        SettingsPage(isPresenting: $showSettings).navigationTitle("Settings")
                    }
                })
        }
    }
}

#Preview {
    ContentView()
}
