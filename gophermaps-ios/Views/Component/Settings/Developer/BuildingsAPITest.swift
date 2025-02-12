//
//  BuildingsAPITest.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 1/31/25.
//

import SwiftUI

struct BuildingsAPITest: View {
    @State private var selectedArea: Components.Schemas.AreaName = .allCases.first!
    @State private var apiResponseRaw: String?
    
    var body: some View {
        List {
            Section {
                Picker("Area", selection:$selectedArea) {
                    ForEach(Components.Schemas.AreaName.allCases, id:\.rawValue) { choice in
                        Text(choice.rawValue).tag(choice)
                    }
                }
            }
            
            Button("Test Call") {
                Task {
                    let response = try await apiClient.getBuildingsForArea(
                        Operations.getBuildingsForArea.Input(path: .init(area: selectedArea))
                    )
                    
                    switch response {
                    case let .ok(okResponse):
                        print("getBuildings succeeded")
                            apiResponseRaw = String(describing: try! okResponse.body.json)
                    case .unprocessableContent(_):
                        print("getBuildings failed (unprocessableContent)")
                        apiResponseRaw = "Failed"
                    case .undocumented(statusCode: let statusCode, _):
                        print("getBuildings failed: \(statusCode)")
                        apiResponseRaw = "Code \(statusCode)"
                    }
                }
            }
            
            Text(apiResponseRaw ?? "No response yet")
        }
    }
}

#Preview {
    BuildingsAPITest()
}
