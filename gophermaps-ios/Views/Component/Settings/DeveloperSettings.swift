//
//  DeveloperSettings.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/2/24.
//

import SwiftUI
import OpenAPIURLSession

let apiServerChoices: [(String, URL)] = [
    ("Production", try! Servers.server1()),
    ("LocalHost", try! Servers.server2())
]

struct DeveloperSettings: View {
    @State var selectedServer: URL? = try! Servers.server1()
    
    var body: some View {
        List {
            Picker("API Server", selection: $selectedServer) {
                ForEach(apiServerChoices, id:\.0) { option in
                    Text(option.0).tag(option.1)
                }
            }.onChange(of: selectedServer!) {_, newValue in
                print("Changed server to \(newValue)")
                apiClient = Client(serverURL: newValue, transport: URLSessionTransport())
            }
            
            Section("API Tests") {
                SettingsLink("GetBuildingsForArea", icon: "building.2.crop.circle", iconBackground: .purple) {
                    BuildingsAPITest()
                }
            }
            
            Section("Other") {
                SettingsLink("Browse Documents", icon: "folder.fill", iconBackground: .blue) {
                    DocumentsDebugView()
                }
                SettingsLink("Haptic Tests", icon: "iphone.gen3.radiowaves.left.and.right", iconBackground: .gray) {
                    HapticTestsView()
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperSettings()
    }
}
