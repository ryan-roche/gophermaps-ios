//
//  SavedRoutesView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 9/12/24.
//
// TODO: Add ability to add/remove routes from the list view

import SwiftUI
import SwiftData

struct SavedRoutesView: View {

    @Binding var showing: Bool
    @Binding var presentation: Bool
    @Binding var savedRouteSelection: SavedRoute?
    
    @Query(sort:
            [SortDescriptor(\SavedRoute.start.buildingName), SortDescriptor(\SavedRoute.end.buildingName)]
    ) var savedRoutes: [SavedRoute]
    
    var body: some View {
        if savedRoutes.isEmpty {
            ContentUnavailableView("No Saved Routes", systemImage:"bookmark.slash")
                .foregroundStyle(.secondary)
            }
        } else {
            // MARK: List of saved route cards
            List {
                ForEach(savedRoutes) { route in
                    Button {
                        savedRouteSelection = route
                        print("Set route selection.")
                        presentation.toggle()
                        showing = false
                    } label: {
                        SavedRouteCard(route)
                            .frame(height: 120)
                            .shadow(radius:4, y:2)
                            .buttonStyle(.plain)
                            .overlay {
                                HStack {
                                    Spacer()
                                    Image(systemName:"chevron.forward")
                                        .padding(.trailing, 8)
                                        .foregroundStyle(.secondary)
                                        .fontWeight(.medium)
                                }
                            }
                    }
                    .listRowSeparator(.hidden, edges: .all)
                }
            }.listStyle(.plain)
        }
    }
}

#if DEBUG
#Preview {
    @Previewable @State var showing: Bool = true
    @Previewable @State var presenting: Bool = false
    @Previewable @State var savedRouteSelection: SavedRoute? = nil
    
    NavigationStack {
        VStack {
            Text("Route Selection:")
            Text("\(savedRouteSelection?.start.buildingName ?? "None") → \(savedRouteSelection?.end.buildingName ?? "None")")
            
            Button("Show Sheet") {
                showing.toggle()
            }
        }
        .navigationTitle("Dummy")
        .sheet(isPresented: $showing) {
            SavedRoutesView(showing: $showing, presentation: $presenting, savedRouteSelection: $savedRouteSelection)
                .modelContainer(previewContainer)
        }
    }
}
#endif
