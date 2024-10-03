//
//  SettingsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/20/24.
//

import SwiftUI

struct SettingsLink<Destination: View, IconBackground: ShapeStyle>: View {
    
    let label: String
    let icon: String
    let iconBackground: IconBackground
    let destination: Destination
    
    init(_ label: String, icon: String, iconBackground: IconBackground, @ViewBuilder destination: () -> Destination) {
        self.label = label
        self.icon = icon
        self.iconBackground = iconBackground
        self.destination = destination()
    }
    
    var body: some View {
        
        NavigationLink {
            destination
                .navigationTitle(label)
        } label: {
            ZStack {
                Image(systemName: "app.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30)
                    .foregroundStyle(iconBackground)
                Image(systemName: icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20)
                    .foregroundStyle(.white)
            }.padding(.leading, -6)
            
            Text(label)
            
        }
        
    }
}

struct SettingsView: View {
    @Binding var showing: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                List {
                    
                    // MARK: Appearance
                    // Appearance settings go here
                    
                    // MARK: System
                    Section(header: Text("System")) {
                        SettingsLink("Data Management", icon: "externaldrive.fill", iconBackground: .secondary) {
                            DataSettingsView()
                        }
                    }
                    
                    // MARK: About
                    Section(header: Text("About")) {
                        SettingsLink("Version Info", icon:"info.circle", iconBackground: .cyan) {
                            VersionDetails()
                        }
                    }
                    
                    // MARK: Developer Settings
                    Section() {
                        SettingsLink("Debug Settings",
                                     icon:"hammer.fill",
                                     iconBackground:.tertiary) {
                            DeveloperSettings()
                        }
                    }
                    
                }.listStyle(.insetGrouped)
            }
            .overlay(alignment: .bottom) {
                ProfileCards()
            }
            .navigationTitle("Settings")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        showing = false
                    }
                }
            }
        }
    }
}

#Preview {
    @Previewable @State var showing: Bool = true
    SettingsView(showing: $showing)
        .modelContainer(previewContainer)
}
