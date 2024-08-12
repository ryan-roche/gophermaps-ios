//
//  AreaSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//

import SwiftUI
import OpenAPIRuntime
import OpenAPIURLSession

struct AreaSelectorView: View {
    @State var areas: [Components.Schemas.AreaModel] = []
    @State var areasHaveLoaded = false
    
    var body: some View {
        if areasHaveLoaded {
            List {
                ForEach(areas, id: \.self) {area in
                    Text(area.name.value1.rawValue)
                }
            }
        } else {
            ProgressView("Getting Areas...")
                .onAppear {
                    Task { try! await populateAreas() }
                }
        }
    }
    
    let client: Client
    
    init() {
        self.client = Client(
            serverURL: try! Servers.server1(),
            transport: URLSessionTransport()
        )
    }
    
    func populateAreas() async throws {
        let response = try await client.getAreas(Operations.getAreas.Input())
        
        switch response {
            case let .ok(okResponse):
                self.areas = try okResponse.body.json
                areasHaveLoaded = true
                break
            
            case .undocumented(statusCode: let statusCode, _):
                print("getAreas failed: \(statusCode)")
                break
        }
    }
}

#Preview {
    AreaSelectorView()
}
