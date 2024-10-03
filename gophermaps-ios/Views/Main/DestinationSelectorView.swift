//
//  DestinationSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/15/24.
//
// TODO: ditto from BuildingSelectorView

import SwiftUI

struct DestinationSelectorView: View {
    
    @State private var vm: DestinationViewModel
    
    init(_ building: Components.Schemas.BuildingEntryModel) {
        self.vm = .init(building: building)
    }
    
    var body: some View {
        switch vm.status {
            case .idle:
                Color.clear.onAppear {
                    Task {
                        do {
                            try await vm.getDestinations()
                        } catch {
                            vm.status = .offline
                        }
                    }
                    vm.status = .loading
                }
            case .loading:
                LoadingView(symbolName:"mappin.and.ellipse", label:"Loading destinations...")
                    .symbolEffect(.pulse, isActive: true)
            case .done:
                if vm.destinations.isEmpty {
                    ContentUnavailableView("No destinations found", systemImage:"questionmark.circle.dashed")
                } else {
                    List {
                        Text("Where to?")
                        ForEach(vm.filteredDestinations.sorted(by:{$0.buildingName < $1.buildingName}), id: \.self) { destination in
                            
                            // Workaround to hide list disclosure chevron
                            ZStack {
                                ImageCard(building: destination, showsChevron: true)
                                    .shadow(radius:4, y:2)
                                    .frame(height: 200)
                                NavigationLink {
                                    RouteDetailsView(vm.building, destination)
                                        .navigationTitle("Your Route")
                                } label: {
                                    EmptyView()
                                }
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
                ContentUnavailableView("Load failed", systemImage:"exclamationmark.magnifyingglass")
                    .foregroundStyle(.secondary)
        }
    }
}

@Observable class DestinationViewModel {
    let building: Components.Schemas.BuildingEntryModel
    
    var destinations: [Components.Schemas.BuildingEntryModel] = []
    var status: apiCallState = .idle
    var searchText: String = ""
    
    init(building: Components.Schemas.BuildingEntryModel) {
        self.building = building
    }
    
    var filteredDestinations: [Components.Schemas.BuildingEntryModel] {
        if searchText.isEmpty {
            return destinations
        } else {
            return destinations.filter { $0.buildingName.localizedCaseInsensitiveContains(searchText) }
        }
    }
    
    @MainActor
    func getDestinations() async throws {
        let response = try await apiClient.getDestinationsForBuilding(
            Operations.getDestinationsForBuilding.Input(path: .init(building: building.buildingName))
        )
        
        switch response {
        case let .ok(okResponse):
            self.destinations = try okResponse.body.json
                self.destinations.removeAll { $0.buildingName == building.buildingName }
                status = .done
        case .unprocessableContent(_):
            print("getDestinations failed (unprocessableContent)")
                status = .failed
        case .undocumented(statusCode: let statusCode, _):
            print("getDestinations failed: \(statusCode)")
                status = .failed
        }
    }
}

#Preview {
    NavigationStack {
        DestinationSelectorView( Components.Schemas.BuildingEntryModel(
            buildingName: "Test Building 1",
            thumbnail: "dummy1.png",
            keyID: "tb1")
        ).navigationTitle("Destinations")
    }
}
