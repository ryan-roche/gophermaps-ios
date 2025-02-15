//
//  VersionDetailsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 9/30/24.
//

import SwiftUI

struct VersionDetails: View {
    
    @State private var apiCallState: apiCallState = .idle
    @State var apiVersion: String = "Unknown"
    
    let version: String = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "Unknown"
    
    let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "Unknown"
    
    
    func getAPIVersion() async throws {
        let response = try await apiClient.apiVersion(Operations.apiVersion.Input())
        
        switch response {
            case let .ok(okResponse):
                apiVersion = try okResponse.body.json
                apiCallState = .done
                
            case .undocumented(statusCode: let statusCode, _):
                print("getAPIVersion failed: \(statusCode)")
                apiCallState = .failed
        }
    }
    
    var body: some View {
            
        List {
            Section {
                VStack {
                    Image("AppIconDupe")
                        .resizable()
                        .scaledToFit()
                        .clipShape(RoundedRectangle(cornerRadius:20))
                        .padding(.horizontal, 40)
                        .padding(.bottom, 20)
                    Image("Logo")
                        .resizable()
                        .scaledToFit()
                }.listRowBackground(Color.clear)
            }
            
            LabeledContent("Version", value: version)
            LabeledContent("Build", value: build)
            LabeledContent {
                switch apiCallState {
                    case .idle, .loading:
                        ProgressView()
                    case .done:
                        Text(apiVersion)
                    case .failed, .offline:
                        Text("N/A")
                }
            } label: {
                Text("API Version")
            }
            
        }
        .listStyle(.insetGrouped)
        .listSectionSpacing(20)
        .onAppear { Task {
                do {
                    try await getAPIVersion()
                } catch {
                    apiCallState = .failed
                }
            }
        }
#if DEBUG
        .overlay(alignment: .bottom) {
            DevBuildBadge()
        }
#endif
    }
}

#Preview {
    VersionDetails()
}
