//
//  DeveloperSettingsPage.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/18/24.
//

import SwiftUI

struct DeveloperSettingsPage: View {
    @AppStorage("goButtonOnLeft") var goButtonOnLeft : Bool = true
    @AppStorage("serverAddress") var serverAddress : String = "placeholder"
    
    var body: some View {
        List {
            Section("Raw Userdefaults") {
                Toggle(isOn: $goButtonOnLeft, label: {Text("goButtonOnLeft")})
                HStack {
                    Text("serverAddress")
                    TextField("0.0.0.0", text: $serverAddress).multilineTextAlignment(.trailing)
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        DeveloperSettingsPage().navigationTitle("Developer")
    }
}
