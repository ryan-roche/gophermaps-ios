//
//  SaveRouteButton.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/12/25.
//


struct SaveRouteButton: View {
    @Query var matchingSavedRoutes: [SavedRoute]
    @Environment(\.modelContext) var context
    
    let start: Components.Schemas.BuildingEntryModel
    let end: Components.Schemas.BuildingEntryModel
    
    init(_ start: Components.Schemas.BuildingEntryModel,
         _ end: Components.Schemas.BuildingEntryModel) {
        
        self.start = start
        self.end = end
        
        _matchingSavedRoutes = Query(filter: #Predicate<SavedRoute> {
            $0.start.keyID == start.keyID && $0.end.keyID == end.keyID
        })
    }
    
    var body: some View {
        Button {
            if !matchingSavedRoutes.isEmpty {
                // Get handle to model object and delete from context
                let routeObject = matchingSavedRoutes.first!
                context.delete(routeObject)
            } else {
                // Create model object and save to context
                let routeObject = SavedRoute(start: start, end: end)
                context.insert(routeObject)
            }
        } label: {
            Image(systemName: !matchingSavedRoutes.isEmpty ? "bookmark.fill" : "bookmark")
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.bordered)
    }
}