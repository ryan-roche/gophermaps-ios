//
//  RouteDetailsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/15/24.
//
// TODO: Modify backend to disambiguate between tunnels and skyways in the response

import SwiftUI

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
    case changeFloor(to: String)
    case changeBuilding(method: BuildingLink)
}

/// Represents a type of connection between two buildings
enum BuildingLink: Identifiable {
    var id: Self {
        return self
    }

    case tunnel
    case skyway
}

struct RouteDetailsView: View {
    @State var stepGroups: [RouteBuildingGroup] = []
    @State var routeLoadStatus: apiCallState = .idle

    let startNode: String
    let endNode: String

    init(_ startNode: String, _ endNode: String) {
        self.startNode = startNode
        self.endNode = endNode
    }

    var body: some View {
        switch routeLoadStatus {
            case .idle:
                Color.clear.onAppear {
                    Task { try! await getRoute() }
                    routeLoadStatus = .loading
                }
            case .loading:
                ProgressView("Calculating Route...")
            case .done:
                ScrollView {
                    VStack(spacing: 20) {
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
                                    .overlay(alignment: .topTrailing) {
                                        KeyBuildingBadge(
                                            stepGroup.position == .start
                                                ? .start : .end
                                        )
                                        .padding(10)
                                    }
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
                                    RouteStepCard(step).padding(.horizontal)
                                        .shadow(radius: 4, y: 2)
                                }
                            }.compositingGroup()
                            if stepGroup.position != .end {
                                Image(systemName: "arrow.down")
                                    .foregroundStyle(.secondary)
                                    .fontWeight(.bold)
                            }
                        }
                    }.padding()
                }
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

            routeStepHelper(routeNodes, thumbnailDict)
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
        _ thumbnailDict: [String: String]
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
                stepGroups.append(
                    RouteBuildingGroup(
                        name: nodes[index].buildingName,
                        thumbnail: thumbnailDict[nodes[index].buildingName]!,
                        position: .end,
                        steps: []
                    ))
                // TODO: add edge type logic
                stepGroups[stepGroups.endIndex - 2].steps.append(.changeBuilding(method: .tunnel))
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
                    stepGroups[stepGroups.endIndex - 2].steps.append(
                        .changeBuilding(method: .tunnel))
                }

                // If the node's building IS the same as the preceeding node's, add a changeFloor step to the current group
                else {
                    // Add a changeFloor step to the tailing group
                    stepGroups[stepGroups.endIndex - 1].steps.append(
                        .changeFloor(to: currentNode.floor))
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        RouteDetailsView("tb1", "tb3")
            .navigationTitle("Your Route")
    }
}
