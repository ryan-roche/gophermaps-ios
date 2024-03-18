//
//  RoutePreviewView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI

struct RouteSteps: View {
    let start: BuildingEntry
    let end: BuildingEntry
    
    @ScaledMetric(relativeTo:.title3) private var cardSpacing = 16
    
    @State private var showingSheet = false
    @State private var downloadingRoute = false
    
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
        
        // TODO: Add animation for route "loading in"
        
        NavigationStack {
            ScrollView {
                VStack(spacing:cardSpacing) {
                    // Iterate over route steps + indices
                    ForEach(Array(getBuildingsFromRoute(route: getRouteForNodes(start: start, end: end)).enumerated()), id:\.element) { index, element in
                        HStack(spacing:12) {
                            
                            // MARK: Step number
                            Circle()
                                .frame(width:24)
                                .overlay(Text(String(index + 1)).foregroundStyle(.background))
                            
                            // MARK: Building Card
                            PreviewBuildingCard(building: element).shadow(color:Color.black.opacity(0.14), radius: 4)
                            
                        }.padding(.horizontal)
                    }
                }
            }.overlay(alignment: UserDefaults.standard.bool(forKey: "goButtonOnLeft") ? .bottomLeading : .bottomTrailing) {
                RouteGoButton(onTap:{
                    await Backend.downloadRouteData(route: getRouteForNodes(start: start, end: end))
                    showingSheet.toggle()
                }).padding(.bottom).padding([.leading, .trailing])
            }
        }.sheet(isPresented: $showingSheet, content: {
            InstructionNavigator(route: previewShortNavRoute)
        })
    }
}

#Preview {
    RouteSteps(start: previewTateHall, end: previewKellerHall)
}
