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
            SettingsLink("Browse Documents", icon: "folder.fill", iconBackground: .blue) {
                DocumentsDebugView()
            }
            SettingsLink("Haptic Tests", icon: "iphone.gen3.radiowaves.left.and.right", iconBackground: .gray) {
                HapticTestsView()
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperSettings()
    }
}
