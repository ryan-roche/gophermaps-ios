//
//  RoutePreviewView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI

struct RoutePreviewView: View {
    var body: some View {
    
        // Displays a throbber as the building sequence is loaded from the REST API
        // Once the building sequence is loaded, the node list is parsed to create a building list
        // The building list is then displayed using BuildingCards
        
        // A "Go" button is displayed at the bottom of the screen, but is disabled whilst the building list is being downloaded
        // Once the building list is downloaded the button is enabled
        // Clicking the button will download the route data, replacing the "Go" text on the button with a throbber (possibly a progress bar)
        // Once the data is downloaded, it creates a list of markdown files using the n4j node ids returned by the REST API
        // Each building in the sequence gets a RouteSlice model, which contains the list of markdown files for that segment (i.e how to get from Smith Hall to the adjacent Walter Library)
        // Once all calculations are done, the RouteSliceView for the first RouteSlice is pushed onto the navigation stack
        
        NavigationStack {
            Text("Route Preview View")
        }
        
    }
}

#Preview {
    RoutePreviewView()
}
