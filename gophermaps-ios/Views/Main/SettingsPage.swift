//
//  SettingsPage.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/16/24.
//

import SwiftUI

struct SettingsPage: View {
    @Environment(\.dismiss) var dismiss
    
    @State var showDevSettings = false
    
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
            ToolbarItem(placement: .automatic) {Button("Done") { dismiss() } }
        }
    }
}

#Preview {
    NavigationStack {
        SettingsPage().navigationTitle("Settings")
    }
}
