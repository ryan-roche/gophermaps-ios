//
//  BuildingSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/13/24.
//

import SwiftUI

struct BuildingSelectorView: View {
    @State var buildings: [Components.Schemas.BuildingEntryModel] = []
    @State var buildingLoadStatus: apiCallState = .idle
    
    let area: Components.Schemas.AreaModel
    
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
                    ScrollView {
                        VStack(alignment: .leading, spacing:16) {
                            
                            Text("Where do you want to **start from**?")
                            
                            ForEach(buildings, id: \.self) { building in
                                NavigationLink(
                                    destination: {
                                        DestinationSelectorView(building: building)
                                            .navigationTitle("Destination")
                                    }, label: {
                                        ImageCard(building: building, showsChevron: true)
                                            .shadow(radius:4, y:2)
                                            .frame(height: 200)
                                    }
                                ).buttonStyle(.plain)
                            }
                        }.padding()
                    }
                }
            case .failed:
                ContentUnavailableView("Failed to load Buildings", systemImage:"exclamationmark.magnifyingglass")
                    .foregroundStyle(.secondary)
        }
    }
    
    func populateBuildings() async throws {
        let response = try await apiClient.getBuildingsForArea(
            Operations.getBuildingsForArea.Input(path: .init(area: .init(value1: area.name.value1))))
        
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
            name: Components.Schemas.AreaModel.namePayload(value1: .East_space_Bank),
            thumbnail: "dummy1.png")
        ).navigationTitle("Buildings")
    }
}
