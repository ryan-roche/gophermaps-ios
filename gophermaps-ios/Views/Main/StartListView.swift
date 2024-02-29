//
//  StartListView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI

struct StartListView: View {
    let startingPoints: [BuildingEntry]
    @ScaledMetric(relativeTo:.title3) var cardSpacing = 8
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing:cardSpacing) {
                    Text("Available starting points:")
                        .padding(.leading)
                        .frame(maxWidth:.infinity, alignment:.leading)
                    
                    // List out the cards in alphabetical order
                    ForEach(startingPoints.sorted(by: {$0.name < $1.name}), id:\.name) { entry in
                        NavigationLink {
                            DestinationListView(destinationsFor: entry)
                        } label: {
                            BuildingCard(building: entry)
                        }.buttonStyle(.plain)
                    }
                }
            }.navigationTitle("Where are you?")
        }
    }
}

#Preview {
    StartListView(startingPoints: previewBuildings())
        .overlay {
            Label(
                title: { Text("Gophermaps development build") },
                icon: { Image(systemName: "hammer.circle") }
            )
            .padding()
            .foregroundStyle(.primary)
            .background(.thinMaterial, in: Capsule())
            .frame(maxWidth:.infinity, maxHeight:.infinity, alignment:.bottom)
        }
}
