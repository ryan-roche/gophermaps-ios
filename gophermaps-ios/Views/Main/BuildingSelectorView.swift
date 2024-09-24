//
//  BuildingSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/13/24.
//
// TODO: Fix search bar visibility (use wrapper ViewBuilder??)

import SwiftUI

struct BuildingSelectorView: View {
    @State var buildings: [Components.Schemas.BuildingEntryModel] = []
    @State var buildingLoadStatus: apiCallState = .idle
    
    @State var searchText: String = ""
    
    let area: Components.Schemas.AreaModel
    
    var filteredBuildings: [Components.Schemas.BuildingEntryModel] {
        if searchText.isEmpty {
            return buildings
        } else {
            return buildings.filter { $0.buildingName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        switch buildingLoadStatus {
            case .idle:
                Color.clear.onAppear {
                    buildingLoadStatus = .loading
                    Task { try! await populateBuildings() }
                }
            case .loading:
                ProgressView("Loading Buildings...")
            case .done:
                if buildings.isEmpty {
                    ContentUnavailableView("No buildings found", systemImage:"questionmark.circle.dashed")
                        .foregroundStyle(.secondary)
                } else {
                    List {
                        ForEach(filteredBuildings.sorted(by:{$0.buildingName < $1.buildingName}), id: \.self) { building in
                            
                            // Workaround to hide list disclosure chevron
                            ZStack {
                                NavigationLink {
                                    DestinationSelectorView(building: building).navigationTitle("Destination")
                                } label: {
                                    EmptyView()
                                }
                                ImageCard(building: building, showsChevron: true)
                                    .shadow(radius:4, y:2)
                                    .frame(height: 200)
                            }
                            .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchText, prompt:"Building Name")
                }
            case .failed:
                ContentUnavailableView("Failed to load Buildings", systemImage:"exclamationmark.magnifyingglass")
                    .foregroundStyle(.secondary)
        }
    }
    
    func populateBuildings() async throws {
        let response = try await apiClient.getBuildingsForArea(
            Operations.getBuildingsForArea.Input(path: .init(area: area.name))
        )
        
        switch response {
        case let .ok(okResponse):
            self.buildings = try okResponse.body.json
                buildingLoadStatus = .done
        case .unprocessableContent(_):
            print("getBuildings failed (unprocessableContent)")
                buildingLoadStatus = .failed
        case .undocumented(statusCode: let statusCode, _):
            print("getBuildings failed: \(statusCode)")
                buildingLoadStatus = .failed
        }
    }
}

#Preview {
    NavigationStack {
        BuildingSelectorView(area: Components.Schemas.AreaModel(
            name: Components.Schemas.AreaName.East_space_Bank, thumbnail: "dummy1.png")
        ).navigationTitle("Start Building")
    }
}
