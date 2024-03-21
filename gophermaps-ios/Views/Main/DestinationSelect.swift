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
struct DestinationSelect: View {
    let destinationsFor: BuildingEntry
    
    @State var destinationsFetched = false
    @State var destinations: [BuildingEntry] = []
    
    var body: some View {
        ScrollView {
            if (destinationsFetched) {
                VStack {
                    Text("Available destinations for \(destinationsFor.name):")
                        .padding(.leading)
                        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment:.leading)
                    
                    // List destinations sorted by name
                    ForEach(destinations.sorted(by: {$0.name < $1.name}), id:\.name) { destination in
                        NavigationLink {
                            RouteSteps(start: destinationsFor, end: destination).navigationTitle("Route Preview")
                        } label: {
                            HStack {
                                MenuBuildingCard(building: destination).shadow(color:Color.black.opacity(0.1),radius: 2, y:3)
                                Image(systemName: "chevron.forward")
                            }.padding(.horizontal)
                        }.buttonStyle(.plain)
                    }
                }
            } else {
                ProgressView("Getting Destinations").padding()
            }
        }.navigationTitle("Where to?")
            .task {
            do {
                try destinations = await BackendStubs.getDestinations(start: destinationsFor)
                destinationsFetched = true
            } catch {
                print("getDestinations failed")
            }
        }
    }
}

#Preview {
    NavigationStack {
        DestinationSelect(destinationsFor: previewTateHall)
    }
}
