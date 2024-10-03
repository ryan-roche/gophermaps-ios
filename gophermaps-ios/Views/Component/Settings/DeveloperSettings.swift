//
//  DeveloperSettings.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/2/24.
//

import SwiftUI

struct DeveloperSettings: View {
    var body: some View {
        List {
            SettingsLink("Browse Instructions", icon: "folder.fill", iconBackground: .blue) {
                DataSettingsView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperSettings()
    }
}
