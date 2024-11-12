//
//  AreaSelectorView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/10/24.
//
// TODO: Fix on-tap appearance (polish)

import SwiftUI

struct AreaSelectorView: View {
    @State var areas: [Components.Schemas.AreaModel] = []
    @State var areaLoadStatus: apiCallState = .idle
    
    @State var serverAnnouncement: ServerMessageModel?
    @State var showingAnnouncement: Bool = true
    
    var body: some View {
        switch areaLoadStatus {
            case .idle:
                Color.clear.onAppear {
                    areaLoadStatus = .loading
                    Task {
                        do {
                            try await populateAreas()
                        } catch {
                            areaLoadStatus = .offline
                        }
                    }
                    Task {
                        await getServerMessage()
                    }
                }
            case .loading:
                LoadingView(symbolName: "map", label: "Getting Areas...")
            case .done:
                VStack(spacing:16) {
                    if (serverAnnouncement != nil) && showingAnnouncement {
                        AnnouncementCardView(message: serverAnnouncement!, isShowing: $showingAnnouncement)
                            .multicolorGlow(serverAnnouncement!.colorObjects)
                    }
                    
                    ForEach(areas, id: \.self) {area in
                        NavigationLink(
                            destination: {
                                BuildingSelectorView(area: area)
                                    .navigationTitle("Start Building")
                            },
                            label: {
                                ImageCard(area: area, showsChevron: true)
                                    .shadow(radius:4, y:2)
                            }
                        )
                        .buttonStyle(.plain)
                        .contentShape(Rectangle())  // For some reason, this fixes the incorrect hitbox issue
                    }
                }.padding()
            case .offline:
                NetworkOfflineMessage()
            case .failed:
                ContentUnavailableView("Failed to load Areas", systemImage: "exclamationmark.magnifyingglass")
        }
    }
    
    func populateAreas() async throws {
        let response = try await apiClient.getAreas(Operations.getAreas.Input())
        
        switch response {
            case let .ok(okResponse):
                self.areas = try okResponse.body.json
                areaLoadStatus = .done
            
            case .undocumented(statusCode: let statusCode, _):
                print("getAreas failed: \(statusCode)")
                areaLoadStatus = .failed
        }
    }
    func getServerMessage() async {
        do {
            self.serverAnnouncement = try await DownloadManager.shared.getServerMessage()
        } catch {
            print("failed to get server message: \(error)")
        }
    }
}

#Preview {
    NavigationStack {
        AreaSelectorView()
    }
}
