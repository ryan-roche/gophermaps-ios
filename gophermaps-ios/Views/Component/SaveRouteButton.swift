//
//  SaveRouteButton.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/12/25.
//

import SwiftUI
import SwiftData

struct SaveRouteButton: View {
    @Query var savedRoutes: [SavedRoute]
    @Environment(\.modelContext) var context
    
    let start: Components.Schemas.BuildingEntryModel
    let end: Components.Schemas.BuildingEntryModel
    
    init(_ start: Components.Schemas.BuildingEntryModel,
         _ end: Components.Schemas.BuildingEntryModel) {
        
        self.start = start
        self.end = end
    }
    
    var body: some View {
        Button {
            if savedRoutes.contains(where: { $0.start.keyID == start.keyID && $0.end.keyID == end.keyID }) {
                // Get handle to model object and delete from context
                let routeObject = savedRoutes.filter { $0.start.keyID == start.keyID && $0.end.keyID == end.keyID }.first!
                context.delete(routeObject)
            } else {
                // Create model object and save to context
                let routeObject = SavedRoute(start: start, end: end)
                context.insert(routeObject)
            }
        } label: {
            Image(systemName: savedRoutes.contains(where: { $0.start.keyID == start.keyID && $0.end.keyID == end.keyID }) ? "bookmark.fill" : "bookmark")
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.bordered)
    }
}
