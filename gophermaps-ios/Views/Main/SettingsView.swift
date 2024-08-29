//
//  SettingsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/20/24.
//

import SwiftUI

struct SettingsView: View {
    @Binding var showing: Bool
    
    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                Spacer()
                
                Image(systemName:"gearshape")
                    .resizable()
                    .fontWeight(.ultraLight)
                    .scaledToFit()
                    .foregroundStyle(.tertiary)
                    .frame(height: 140)
                Text("You'll find the app's settings here.\nWell, you *would* find them if there were any...\n\nJust remember this place for later.")
                    .multilineTextAlignment(.center)
                    .padding(.top, 20)
                    .padding(.horizontal, 60)
                    .foregroundStyle(.secondary)
                
                Spacer()
                Spacer()
                Spacer()
                
                Divider().padding(.horizontal)
                // MARK: App details
                AboutAppView()
                
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
}
