//
//  DestinationListView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI

/* 
 * Takes a BuildingEntry object
 * Lists the BuildingEntry objects in the destination set of the
 * passed BuildingEntry in alphabetical order
 * Clicking one navigates to a RoutePreviewView with the start and
 * destination BuildingEntry objects passed to it
 */
struct DestinationListView: View {
    let destinationsFor: BuildingEntry
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    Text("Available destinations for \(destinationsFor.name):")
                        .padding(.leading)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment:.leading)
                    
                    // List destinations sorted by name
                    ForEach(destinationsFor.destinations.sorted(by: {$0.name < $1.name}), id:\.name) { destination in
                        NavigationLink {
                            RoutePreviewView().navigationTitle("Route Preview")
                        } label: {
                            BuildingCard(building: destination)
                        }.buttonStyle(.plain)
                    }
                }
            }.navigationTitle("Where to?")
        }
    }
}

#Preview {
    DestinationListView(destinationsFor: destinationPreviewBuilding())
}
