//
//  ContentView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//

import SwiftUI

struct ContentView: View {
    @State private var showingSettings = false
    @State private var showingOnboarding = false
    
    @AppStorage("hasDoneOnboarding") var hasDoneOnboarding: Bool = false
    
    var body: some View {
        NavigationStack {
            AreaSelectorView()
                .navigationTitle("Available Areas")
                .toolbar {
                    ToolbarItem(placement:.topBarTrailing) {
                        Button {
                            showingSettings.toggle()
                        } label: {
                            Image(systemName: "gear")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .padding(6)
                                .background {
                                    Circle()
                                        .fill(.accent)
                                }
                        }
                    }
                }
                .sheet(isPresented: $showingSettings) {
                    SettingsView(showing: $showingSettings)
                }
                .sheet(isPresented: $showingOnboarding) {
                    BetaOnboardingView(showing: $showingOnboarding)
                        .padding(.top)
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
}
