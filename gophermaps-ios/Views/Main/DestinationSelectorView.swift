//
//  DestinationSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/15/24.
//
// TODO: ditto from BuildingSelectorView

import SwiftUI

struct DestinationSelectorView: View {
    @State var destinations: [Components.Schemas.BuildingEntryModel] = []
    @State var destinationLoadStatus: apiCallState = .idle
    
    @State var searchText: String = ""
    
    let building: Components.Schemas.BuildingEntryModel
    
    var filteredDestinations: [Components.Schemas.BuildingEntryModel] {
        if searchText.isEmpty {
            return destinations
        } else {
            return destinations.filter { $0.buildingName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    var body: some View {
        switch destinationLoadStatus {
            case .idle:
                Color.clear.onAppear {
                    Task {
                        do {
                            try await getDestinations()
                        } catch {
                            destinationLoadStatus = .offline
                        }
                    }
                    destinationLoadStatus = .loading
                }
            case .loading:
                LoadingView(symbolName: "mappin", label: "Loading Destinations...")
            case .done:
                if destinations.isEmpty {
                    ContentUnavailableView("No destinations found", systemImage:"questionmark.circle.dashed")
                } else {
                    List {
                        Text("Where to?")
                        ForEach(filteredDestinations.sorted(by:{$0.buildingName < $1.buildingName}), id: \.self) { destination in
                            
                            // Workaround to hide list disclosure chevron
                            ZStack {
                                ImageCard(building: destination, showsChevron: true)
                                    .shadow(radius:4, y:2)
                                    .frame(height: 200)
                                NavigationLink {
                                    RouteDetailsView(building, destination)
                                        .navigationTitle("Your Route")
                                } label: {
                                    EmptyView()
                                }
                            }
                            .listRowSeparator(.hidden, edges: .all)
                        }
                    }
                    .listStyle(.plain)
                    .searchable(text: $searchText, prompt:"Building Name")
                }
            case .offline:
                NetworkOfflineMessage()
            case .failed:
                ContentUnavailableView("Load failed", systemImage:"exclamationmark.magnifyingglass")
                    .foregroundStyle(.secondary)
        }
    }
    
    func getDestinations() async throws {
        let response = try await apiClient.getDestinationsForBuilding(
            Operations.getDestinationsForBuilding.Input(path: .init(building: building.buildingName))
        )
        
        switch response {
        case let .ok(okResponse):
            self.destinations = try okResponse.body.json
                self.destinations.removeAll { $0.buildingName == building.buildingName }
            destinationLoadStatus = .done
        case .unprocessableContent(_):
            print("getDestinations failed (unprocessableContent)")
            destinationLoadStatus = .failed
        case .undocumented(statusCode: let statusCode, _):
            print("getDestinations failed: \(statusCode)")
            destinationLoadStatus = .failed
        }
    }
}

#Preview {
    NavigationStack {
        DestinationSelectorView(building: Components.Schemas.BuildingEntryModel(
            buildingName: "Test Building 1",
            thumbnail: "dummy1.png",
            keyID: "tb1")
        ).navigationTitle("Destinations")
    }
}
