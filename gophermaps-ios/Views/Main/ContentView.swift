//
//  ContentView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//
// TODO: Add TipKit tip for conditional Saved Routes button

import SwiftUI

struct ContentView: View {
    @State private var showingSavedRoutes = false
    @State private var showingSettings = false
    @State private var showingOnboarding = false
    
    @State private var isViewingSavedRoute = false
    @State private var savedRouteSelection: SavedRoute? = nil
    
    @AppStorage("hasDoneOnboarding") var hasDoneOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            AreaSelectorView()
                .navigationTitle("Areas")
                .navigationDestination(isPresented:$isViewingSavedRoute) {
                    RouteDetailsView(
                        savedRouteSelection?.start ?? Components.Schemas.BuildingEntryModel(buildingName: "placeholder", thumbnail: "placeholder.jpg", keyID: ""),
                        savedRouteSelection?.end ?? Components.Schemas.BuildingEntryModel(buildingName: "placeholder", thumbnail: "placeholder.jpg", keyID: "")
                    )
                    
                }
                .toolbar {
                    ToolbarItemGroup(placement:.topBarTrailing) {
                        Button {
                            showingSavedRoutes.toggle()
                        } label: {
                            Label("Saved", systemImage: "bookmark")
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            showingSettings.toggle()
                        } label: {
                            Image(systemName: "gear")
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView(showing: $showingSettings)
                }
                .sheet(isPresented: $showingOnboarding) {
                    FirstLaunchView(showing: $showingOnboarding)
                        .padding(.top)
                }
                .sheet(isPresented: $showingSavedRoutes) {
                    NavigationStack {
                        SavedRoutesView(
                            showing: $showingSavedRoutes,
                            presentation: $isViewingSavedRoute,
                            savedRouteSelection: $savedRouteSelection)
                            .navigationTitle("Saved Routes")
                    }
                }
            
        }.onAppear {
            if !hasDoneOnboarding {
                showingOnboarding.toggle()
                hasDoneOnboarding = true
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
