//
//  StartListView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI

struct StartingPointSelect: View {
    @ScaledMetric(relativeTo:.title3) var cardSpacing = 10
    
    @State var buildingsFetched = false
    @State var startingPoints: [BuildingEntry]
    
    var body: some View {
        ScrollView {
            if (buildingsFetched) {
                VStack(spacing:cardSpacing) {
                    Text("Available starting points:")
                        .padding(.leading)
                        .frame(maxWidth:.infinity, alignment:.leading)
                    
                    // List out the cards in alphabetical order
                    ForEach(startingPoints.sorted(by: {$0.name < $1.name}), id:\.name) { entry in
                        NavigationLink {
                            DestinationSelect(destinationsFor: entry)
                        } label: {
                            HStack {
                                MenuBuildingCard(building: entry).shadow(color:Color.black.opacity(0.1),radius: 2, y:3)
                                Image(systemName: "chevron.forward")
                            }.padding(.horizontal)
                        }.buttonStyle(.plain)
                    }
                }
            } else {
                ProgressView("Getting Buildings").padding()
            }
        }.navigationTitle("Where are you?").task {
            do {
                try startingPoints = await BackendStubs.getBuildings(area: "TestBuildings")
                buildingsFetched = true
            } catch {
                print("getBuildings failed")
            }
        }
    }
}

#Preview {
    NavigationStack {
        StartingPointSelect(startingPoints: previewBuildings)
    }
}
