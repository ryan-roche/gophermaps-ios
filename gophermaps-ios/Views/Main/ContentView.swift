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
            
                // MARK: Main View toolbar
                .toolbar {
#if DEBUG
                    ToolbarItem(placement: .topBarLeading) {
                        DevBuildBadge()
                            .frame(maxWidth:.infinity)
                            .padding(10)
                            .background(
                                FrostedGlassView(effect: .systemThickMaterial)
                                    .clipShape(Capsule())
                                    .shadow(color:.black.opacity(0.2), radius:4, y:2)
                            )
                    }
#endif
                    
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
            
                // MARK: Settings Sheet
                .sheet(isPresented: $isShowingSettingsSheet) {
                    SettingsView(showing: $isShowingSettingsSheet)
                }
            
                // MARK: Onboarding Sheet
                .sheet(isPresented: $showingOnboarding) {
                    FirstLaunchView(showing: $showingOnboarding)
                        .padding(.top)
                }
            
                // MARK: Saved Routes Sheet
                .sheet(isPresented: $isShowingSavedRoutesSheet) {
                    NavigationStack {
                        SavedRoutesView(
                            showing: $isShowingSavedRoutesSheet,
                            presentation: $isViewingSavedRoute,
                            savedRouteSelection: $savedRouteSelection
                        )
                        .navigationTitle("Saved Routes")
                        .toolbar {
                            ToolbarItem(placement: .topBarTrailing) {
                                Button("Done") {
                                    isShowingSavedRoutesSheet = false
                                }
                            }
                        }
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
