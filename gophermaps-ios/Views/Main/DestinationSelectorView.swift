//
//  DestinationSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/15/24.
//
// TODO: Remove self from destinations

import SwiftUI

struct DestinationSelectorView: View {
    @State var destinations: [Components.Schemas.BuildingEntryModel] = []
    @State var destinationLoadStatus: apiCallState = .idle
    
    let building: Components.Schemas.BuildingEntryModel
    
    var body: some View {
        switch destinationLoadStatus {
            case .idle:
                Color.clear.onAppear {
                    Task { try! await getDestinations() }
                    destinationLoadStatus = .loading
                }
            case .loading:
                ProgressView("Loading Destinations...")
            case .done:
                if destinations.isEmpty {
                    ContentUnavailableView("No destinations found", systemImage:"questionmark.circle.dashed")
                } else {
                    ScrollView {
                        VStack(alignment: .leading, spacing:16) {
                            
                            Text("Buildings reachable from **\(building.buildingName)**")
                            
                            ForEach(destinations, id: \.self) { destination in
                                NavigationLink(
                                    destination: {
                                        RouteDetailsView(building.keyID, destination.keyID)
                                            .navigationTitle("Route")
                                    }, label: {
                                        ImageCard(building: destination, showsChevron: true)
                                            .shadow(radius:4, y:2)
                                            .frame(height: 200)
                                    }
                                ).buttonStyle(.plain)
                            }
                            
                        }.padding()
                    }
                }
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
