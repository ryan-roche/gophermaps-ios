//
//  AreaSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//
// TODO: Fix on-tap appearance (non-MVP)

import SwiftUI

struct AreaSelectorView: View {
    
    @State private var vm = AreaViewModel()
    
    var body: some View {
        switch vm.status {
            case .idle:
                Color.clear.onAppear {
                    vm.status = .loading
                    Task {
                        do {
                            try await vm.populateAreas()
                        } catch {
                            vm.status = .offline
                        }
                    }
                }
            case .loading:
                LoadingView(symbolName: "map", label: "Getting Areas...")
                    .symbolEffect(.pulse, isActive: true)
                
            case .done:
                VStack(spacing:16) {
                    Text("Select an area to get started.")
                        .frame(maxWidth:.infinity, alignment: .leading)
                    ForEach(vm.areas, id: \.self) {area in
                        NavigationLink(
                            destination: {
                                BuildingSelectorView(area)
                                    .navigationTitle("Start Building")
                            },
                            label: {
                                ImageCard(area: area, showsChevron: true)
                                    .shadow(radius:4, y:2)
                            }
                        ).buttonStyle(.plain)
                    }
                }.padding()
            case .offline:
                NetworkOfflineMessage()
            case .failed:
                ContentUnavailableView("Failed to load Areas", systemImage: "exclamationmark.magnifyingglass")
        }
    }
}

@Observable class AreaViewModel {
    var status: apiCallState = .idle
    var areas: [Components.Schemas.AreaModel] = []
    
    @MainActor
    func populateAreas() async throws {
        let response = try await apiClient.getAreas(Operations.getAreas.Input())
        
        switch response {
            case let .ok(okResponse):
                self.areas = try okResponse.body.json
                withAnimation(.snappy) {
                    status = .done
                }
            
            case .undocumented(statusCode: let statusCode, _):
                print("getAreas failed: \(statusCode)")
                withAnimation {
                    status = .failed
                }
        }
    }
}

#Preview {
    NavigationStack {
        AreaSelectorView()
    }
}
