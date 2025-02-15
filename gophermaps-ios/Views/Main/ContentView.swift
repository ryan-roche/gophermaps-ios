//
//  ContentView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//
// TODO: Add TipKit tip for Saved Routes button

import SwiftUI

struct ContentView: View {
    var body: some View {
        MapView()
        #if DEBUG
            .overlay(alignment:.top) {
                DevBuildBadge()
                    .padding()
                    .background(FrostedGlassView(effect: .systemThickMaterial))
                    .clipShape(Capsule())
            }
        #endif
    }
}

#Preview {
    ContentView()
}
