//
//  SettingsPage.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/16/24.
//

import SwiftUI

struct SettingsPage: View {
    @Binding var isPresenting : Bool
    
    var body: some View {
        VStack {
            List {
                // TODO: Selector for "Go" button location
                Toggle(isOn: /*@START_MENU_TOKEN@*/.constant(true)/*@END_MENU_TOKEN@*/, label: {Text("Placeholder")})
                
                Section {
                    NavigationLink {
                        DeveloperSettingsPage().navigationTitle("Developer")
                    } label: { Text("Developer Settings") }
                }
                
            }.listStyle(.insetGrouped)
        }.toolbar {
            ToolbarItem(placement: .automatic) {Button("Done") { isPresenting = false } }
        }
    }
}

struct PreviewWrapper: View {
    @State var showingSettings = true
    
    var body: some View {
        NavigationStack {
            Button("Show Settings") { showingSettings = true }
                .sheet(isPresented: $showingSettings, content: {
                    SettingsPage(isPresenting: $showingSettings)
                        .navigationTitle("Settings")
                })
        }
    }
}

#Preview {
    PreviewWrapper()
}
