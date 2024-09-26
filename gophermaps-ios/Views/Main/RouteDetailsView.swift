//
//  RouteDetailsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/15/24.
//
// TODO: Add TipKit tip for "Save Route" button
// TODO: Add building name to "follow signs" stepcard
// TODO: Add detailedStepsView variant for RouteStepCard

import SwiftUI
import SwiftData

/// Represents a series of RouteSteps taking place in the same building
struct RouteBuildingGroup {
    let name: String
    let thumbnail: String
    let position: BuildingGroupPosition
    var steps: [RouteStep]
}

enum BuildingGroupPosition {
    case start
    case middle
    case end
}

/// Represents a single edge along the route node graph
// TODO: Add bool for wheelchair accessibility
// TODO: Add tunnel/skyway disambiguation
enum RouteStep: Hashable, Identifiable {
    var id: Self {
        return self
    }

    case startAtFloor(to: String)
    case changeFloor(to: String, hasInstructions: Bool,
                     startID: String, endID: String)
    case changeBuilding(method: BuildingLink, hasInstructions: Bool,
                        startID: String, endID: String)
}

/// Represents a type of connection between two buildings
enum BuildingLink: Identifiable {
    var id: Self {
        return self
    }

    case tunnel
    case skyway
}

struct SaveRouteButton: View {
    @Query var matchingSavedRoutes: [SavedRoute]
    @Environment(\.modelContext) var context
    
    let start: Components.Schemas.BuildingEntryModel
    let end: Components.Schemas.BuildingEntryModel
    
    init(_ start: Components.Schemas.BuildingEntryModel,
         _ end: Components.Schemas.BuildingEntryModel) {
        
        self.start = start
        self.end = end
        
        _matchingSavedRoutes = Query(filter: #Predicate<SavedRoute> {
            $0.start.keyID == start.keyID && $0.end.keyID == end.keyID
        })
    }
    
    var body: some View {
        Button {
            if !matchingSavedRoutes.isEmpty {
                // Get handle to model object and delete from context
                let routeObject = matchingSavedRoutes.first!
                context.delete(routeObject)
            } else {
                // Create model object and save to context
                let routeObject = SavedRoute(start: start, end: end)
                context.insert(routeObject)
            }
        } label: {
            Image(systemName: !matchingSavedRoutes.isEmpty ? "bookmark.fill" : "bookmark")
        }
        .buttonBorderShape(.circle)
        .buttonStyle(.bordered)
    }
}

struct RouteDetailsView: View {
    @Environment(\.modelContext) var context
    
    @State var stepGroups: [RouteBuildingGroup] = []
    @State var routeLoadStatus: apiCallState = .idle

    let startBuilding: Components.Schemas.BuildingEntryModel
    let endBuilding: Components.Schemas.BuildingEntryModel
    
    let startNode: String
    let endNode: String

    init(_ start: Components.Schemas.BuildingEntryModel,
         _ end: Components.Schemas.BuildingEntryModel) {
        self.startBuilding = start
        self.endBuilding = end
        self.startNode = start.keyID
        self.endNode = end.keyID
    }

    var body: some View {
        switch routeLoadStatus {
            case .idle:
                Color.clear.onAppear {
                    Task {
                        do {
                            try await getRoute()
                        } catch {
                            routeLoadStatus = .offline
                        }
                    }
                    routeLoadStatus = .loading
                }
            case .loading:
                ProgressView("Calculating Route...")
            case .done:
                ScrollView {
                    // MARK: Route Info Cards
                    VStack(spacing: 20) {
                        HStack {
                            Text(stepGroups[0].name)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                            Image(systemName:"arrow.forward")
                            Text(stepGroups[stepGroups.endIndex-1].name)
                                .fontWeight(.medium)
                                .lineLimit(1)
                                .minimumScaleFactor(0.5)
                        }
                        .padding()
                        .background {
                            FrostedGlassView(effect:.systemMaterial)
                                .clipShape(RoundedRectangle(cornerRadius:8))
                                .shadow(color:.black.opacity(0.2), radius:4, y:2)
                        }
                        
                        // MARK: Route Step Cards
                        ForEach(stepGroups, id: \.name) { stepGroup in
                            Group {
                                // ImageCard for building
                                if stepGroup.position != .middle {
                                    // Large card for first and last building
                                    ImageCard(
                                        label: stepGroup.name,
                                        imageURL: URL(
                                            string: thumbnailBaseURL.appending(
                                                "/buildings/\(stepGroup.thumbnail)")
                                        )!,
                                        layout: .vertical
                                    )
                                    .shadow(radius: 4, y: 2)
                                    .frame(height: 200)
                                } else {
                                    // Smaller card for intermediate buildings
                                    ImageCard(
                                        label: stepGroup.name,
                                        imageURL: URL(
                                            string: thumbnailBaseURL.appending(
                                                "/buildings/\(stepGroup.thumbnail)")
                                        )!,
                                        layout: .horizontal
                                    ).shadow(radius: 4, y: 2)
                                }

                                // RouteStepCards for route steps
                                ForEach(stepGroup.steps) { step in
                                    RouteStepCard(step)
                                        .padding(.horizontal)
                                        .shadow(radius: 4, y: 2)
                                }
                            }
                            
                            if stepGroup.position != .end {
                                Image(systemName: "arrow.down")
                                    .foregroundStyle(.secondary)
                                    .fontWeight(.bold)
                            }
                        }
                    }.padding()
                }.toolbar {
                    // MARK: Save Route Button
                    ToolbarItem(placement: .navigationBarTrailing) {
                        SaveRouteButton(startBuilding, endBuilding)
                    }
                }
            case .offline:
                ContentUnavailableView("You're Offline", systemImage:"wifi.slash")
            case .failed:
                ContentUnavailableView("Load failed", systemImage: "exclamationmark.magnifyingglass")
                    .foregroundStyle(.secondary)
        }
    }

    /// Used to perform and process the API call to get a route between buildings
    func getRoute() async throws {
        let response = try await apiClient.getRoute(
            Operations.getRoute.Input(
                path: .init(start: self.startNode, end: self.endNode))
        )

        switch response {
        case let .ok(okResponse):
                
            // Get route Nodes & building thumbnail names from API
            var routeNodes = try okResponse.body.json.pathNodes
            let thumbnailDict = try okResponse.body.json.buildingThumbnails
                .additionalProperties
            let instructionsAvailable = try okResponse.body.json.instructionsAvailable.additionalProperties

                
            // Preprocess nodes by "trimming" nodes at the beginning and end so that there's only one node with the start/end building
                
            // Trim beginning nodes
            let firstBuilding: String = routeNodes[routeNodes.startIndex]
                .buildingName
            while (routeNodes.count > 1)
                && (routeNodes[routeNodes.startIndex + 1].buildingName
                    == firstBuilding)
            {
                routeNodes.remove(at: routeNodes.startIndex)
            }
                
            // Trim end nodes
            let endBuilding: String = routeNodes[routeNodes.endIndex - 1]
                .buildingName
            while (routeNodes.count > 1)
                && (routeNodes[routeNodes.endIndex - 2].buildingName
                    == endBuilding)
            {
                routeNodes.remove(at: routeNodes.endIndex - 1)
            }

                routeStepHelper(routeNodes, thumbnailDict, instructionsAvailable)
            routeLoadStatus = .done

        case .unprocessableContent(_):
            print("getRouteSteps failed (unprocessableContent)")
            routeLoadStatus = .failed

        case .undocumented(let statusCode, _):
            print("getRouteSteps failed: \(statusCode)")
            routeLoadStatus = .failed
        }
    }

    /// Helper for getRoute - processes routeNodes into routeSteps and building groups
    func routeStepHelper(
        _ nodes: [Components.Schemas.NavigationNodeModel],
        _ thumbnailDict: [String: String],
        _ instructionsBoolDict: [String: Bool]
    ) {

        for index in nodes.indices {
            // First Node: Create a RouteBuildingGroup for the first building and give it a startAtFloor RouteStep
            if index == nodes.startIndex {
                stepGroups.append(
                    RouteBuildingGroup(
                        name: nodes[index].buildingName,
                        thumbnail: thumbnailDict[nodes[index].buildingName]!,
                        position: .start,
                        steps: [RouteStep.startAtFloor(to: nodes[index].floor)])
                )

            }

            // Final Node: Create a RouteBuildlingGroup for the final buidling and a changeBuilding to the previous group
            else if index == nodes.endIndex - 1 {
                let currentNode = nodes[index]
                let previousNode = nodes[index - 1]
                
                stepGroups.append(
                    RouteBuildingGroup(
                        name: currentNode.buildingName,
                        thumbnail: thumbnailDict[nodes[index].buildingName]!,
                        position: .end,
                        steps: []
                    ))
                // TODO: add edge type logic
                stepGroups[stepGroups.endIndex - 2]
                    .steps.append(
                        .changeBuilding(
                            method: .tunnel,
                            hasInstructions: instructionsBoolDict["\(previousNode.navID)-\(currentNode.navID)"] ?? false,
                            startID: previousNode.navID,
                            endID: currentNode.navID)
                    )
            }

            // Middle Nodes: Add a changeFloor step to the current group
            else {
                let currentNode = nodes[index]
                let previousNode = nodes[index - 1]

                // If the node's building is not the same as the preceeding node's (i.e if it's the first node of that building)
                if currentNode.buildingName != previousNode.buildingName {
                    // Create a RouteBuildingGroup for the new building
                    stepGroups.append(
                        RouteBuildingGroup(
                            name: currentNode.buildingName,
                            thumbnail: thumbnailDict[currentNode.buildingName]!,
                            position: .middle,
                            steps: []
                        ))
                    // Add a changeBuilding step to the previous group
                    // TODO: Add edge type logic
                    stepGroups[stepGroups.endIndex - 2]
                        .steps.append(
                            .changeBuilding(
                                method: .tunnel,
                                hasInstructions: instructionsBoolDict["\(previousNode.navID)-\(currentNode.navID)"] ?? false,
                                startID: previousNode.navID,
                                endID: currentNode.navID)
                        )
                }

                // If the node's building IS the same as the preceeding node's, add a changeFloor step to the current group
                else {
                    // Add a changeFloor step to the tailing group
                    stepGroups[stepGroups.endIndex - 1]
                        .steps.append(
                            .changeFloor(
                                to: currentNode.floor,
                                hasInstructions: instructionsBoolDict["\(previousNode.navID)-\(currentNode.navID)"] ?? false,
                                startID: previousNode.navID,
                                endID: currentNode.navID)
                        )
                }
            }
        }
    }
}

#Preview("RouteDetailsView (Unsaved Route)") {
    NavigationStack {
        RouteDetailsView(
            Components.Schemas.BuildingEntryModel(buildingName: "Test Building", thumbnail: "dummy1.jpg", keyID: "tb1"),
            Components.Schemas.BuildingEntryModel(buildingName: "Test Building", thumbnail: "dummy2.jpg", keyID: "tb2")
        )
        .navigationTitle("Your Route")
    }
    .modelContainer(previewContainer)
}

#Preview("RouteDetailsView (Saved Route)") {
    NavigationStack {
        RouteDetailsView(
            sampleRoutes[0].start, sampleRoutes[0].end
        )
        .navigationTitle("Your Route")
    }
    .modelContainer(previewContainer)
}
