//
//  BuildingSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/13/24.
//
// TODO: Fix search bar visibility (use wrapper ViewBuilder??)

import SwiftUI

struct BuildingSelectorView: View {
    
    @State private var vm: BuildingViewModel
    
    init(_ area: Components.Schemas.AreaModel) {
        self.vm = .init(area)
    }
    
    var body: some View {
        switch vm.status {
            case .idle:
                Color.clear.onAppear {
                    vm.status = .loading
                    Task {
                        do {
                            try await vm.populateBuildings()
                        } catch {
                            vm.status = .offline
                        }
                    }
                }
            case .loading:
                LoadingView(symbolName: "building.2", label: "Getting Buildings...")
                    .symbolEffect(.pulse, isActive: true)
            case .done:
                if vm.buildings.isEmpty {
                    ContentUnavailableView("No buildings found", systemImage:"questionmark.circle.dashed")
                        .foregroundStyle(.secondary)
                } else {
                    List {
                        Text("What building are you starting from?")
                        ForEach(vm.filteredBuildings.sorted(by:{$0.buildingName < $1.buildingName}), id: \.self) { building in
                            
                            // Workaround to hide list disclosure chevron
                            ZStack {
                                NavigationLink {
                                    DestinationSelectorView(building).navigationTitle("Destination")
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
                    .searchable(text: $vm.searchText, prompt:"Building Name")
                }
            case .offline:
                NetworkOfflineMessage()
            case .failed:
                ContentUnavailableView("Failed to load Buildings", systemImage:"exclamationmark.magnifyingglass")
                    .foregroundStyle(.secondary)
        }
    }
}

@Observable class BuildingViewModel {
    var buildings: [Components.Schemas.BuildingEntryModel] = []
    var status: apiCallState = .idle
    var searchText: String = ""
    
    let area: Components.Schemas.AreaModel
    
    var filteredBuildings: [Components.Schemas.BuildingEntryModel] {
        if searchText.isEmpty {
            return buildings
        } else {
            return buildings.filter { $0.buildingName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @MainActor
    func populateBuildings() async throws {
        let response = try await apiClient.getBuildingsForArea(
            Operations.getBuildingsForArea.Input(path: .init(area: area.name))
        )
        
        switch response {
        case let .ok(okResponse):
            self.buildings = try okResponse.body.json
                status = .done
        case .unprocessableContent(_):
            print("getBuildings failed (unprocessableContent)")
                status = .failed
        case .undocumented(statusCode: let statusCode, _):
            print("getBuildings failed: \(statusCode)")
                status = .failed
        }
    }
    
    init(_ area: Components.Schemas.AreaModel) {
        self.area = area
    }
}

#Preview {
    NavigationStack {
        BuildingSelectorView(Components.Schemas.AreaModel(
            name: Components.Schemas.AreaName.East_space_Bank, thumbnail: "dummy1.png")
        ).navigationTitle("Start Building")
    }
}
