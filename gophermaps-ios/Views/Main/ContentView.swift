//
//  ContentView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//
// TODO: Add TipKit tip for Saved Routes button

import SwiftUI
import SwiftData

struct ContentView: View {
    @State private var isShowingSavedRoutesSheet = false
    @State private var isShowingSettingsSheet = false
    @State private var showingOnboarding = false
    
    @State private var isViewingSavedRoute = false
    @State private var savedRouteSelection: SavedRoute? = nil
    
    @AppStorage("hasDoneOnboarding") var hasDoneOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            AreaSelectorView()
                .navigationTitle("Areas")
            
                // "hijacks" the navigation hierarchy to directly present a saved route's steps
                .navigationDestination(isPresented:$isViewingSavedRoute) {
                    RouteDetailsView(
                        savedRouteSelection?.start ?? Components.Schemas.BuildingEntryModel(buildingName: "placeholder", thumbnail: "placeholder.jpg", keyID: ""),
                        savedRouteSelection?.end ?? Components.Schemas.BuildingEntryModel(buildingName: "placeholder", thumbnail: "placeholder.jpg", keyID: "")
                    )
                }
                .toolbar {
                    ToolbarItemGroup(placement:.topBarTrailing) {
                        Button {
                            isShowingSavedRoutesSheet.toggle()
                        } label: {
                            Label("Saved", systemImage: "bookmark.fill")
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            isShowingSettingsSheet.toggle()
                        } label: {
                            Image(systemName: "gear")
                        }
                        .buttonBorderShape(.circle)
                        .buttonStyle(.borderedProminent)
                    }
                }
                .sheet(isPresented: $isShowingSettingsSheet) {
                    SettingsView(showing: $isShowingSettingsSheet)
                }
                .sheet(isPresented: $showingOnboarding) {
                    FirstLaunchView(showing: $showingOnboarding)
                        .padding(.top)
                }
                .sheet(isPresented: $isShowingSavedRoutesSheet) {
                    NavigationStack {
                        SavedRoutesView(
                            showing: $isShowingSavedRoutesSheet,
                            presentation: $isViewingSavedRoute,
                            savedRouteSelection: $savedRouteSelection
                        )
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

#if DEBUG
#Preview {
    ContentView()
        .modelContainer(previewContainer)
}
#endif
