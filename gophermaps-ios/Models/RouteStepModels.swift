//
//  RouteStepModel.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/15/25.
//

/// Represents a group of steps pertaining to a single building within a route
struct RouteBuildingGroup {
    let name: String
    let thumbnail: String
    let position: BuildingGroupPosition
    var steps: [RouteStep]
}

/// Options for where in a route a RouteBuildingGroup is located
enum BuildingGroupPosition {
    case start
    case middle
    case end
}

/// Represents a single "step" of a route, either the very beginning of a route, changing floors or moving to another building
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

/// Options for the type of connection between buildings (currently unused)
enum BuildingLink: Identifiable {
    var id: Self {
        return self
    }

    case tunnel
    case skyway
}
