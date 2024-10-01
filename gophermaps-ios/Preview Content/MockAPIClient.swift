//
//  MockAPIClient.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/12/24.
//

import Foundation

struct MockAPIClient: APIProtocol {
    func apiVersion(_ input: Operations.apiVersion.Input) async throws -> Operations.apiVersion.Output {
        return .ok(
            Operations.apiVersion.Output.Ok(body: .json("mock"))
        )
    }
    
    
    func getRoute(_ input: Operations.getRoute.Input) async throws -> Operations.getRoute.Output {
        try await Task.sleep(for: .seconds(1))
        
        return .ok(
            Operations.getRoute.Output.Ok(
                body: .json(Components.Schemas.RouteResponseModel.init(
                    pathNodes: [
                        Components.Schemas.NavigationNodeModel(
                            buildingName: "Test Building 1",
                            floor: "1",
                            navID: "tb1",
                            image: "dummy1.png"),
                        Components.Schemas.NavigationNodeModel(
                            buildingName: "Test Building 2",
                            floor: "2",
                            navID: "tb2",
                            image: "dummy2.png"),
                        Components.Schemas.NavigationNodeModel(
                            buildingName: "Test Building 2",
                            floor: "1",
                            navID: "tb2a",
                            image: "dummy2.png"),
                        Components.Schemas.NavigationNodeModel(
                            buildingName: "Test Building 3",
                            floor: "1",
                            navID: "tb3",
                            image: "dummy1.png")
                    ],
                    buildingThumbnails: .init(additionalProperties: [
                        "Test Building 1": "dummy1.png",
                        "Test Building 2": "dummy2.png",
                        "Test Building 3": "dummy1.png"
                    ]),
                    instructionsAvailable: .init(additionalProperties: [
                        "tb1-tb2": false,
                        "tb2-tb2a": false,
                        "tb2a-tb3": false
                    ])
                ))
            )
        )
    }
    
    func getDestinationsForBuilding(_ input: Operations.getDestinationsForBuilding.Input) async throws -> Operations.getDestinationsForBuilding.Output {
        try await Task.sleep(for: .seconds(1))
        return .ok(
            Operations.getDestinationsForBuilding.Output.Ok(
                body: .json([
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building",
                        thumbnail: "dummy1.png",
                        keyID: "db1"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building",
                        thumbnail: "dummy2.png",
                        keyID: "db2"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building",
                        thumbnail: "dummy1.png",
                        keyID: "db3"),
                ])
            )
        )
    }
    
    func getBuildingsForArea(_ input: Operations.getBuildingsForArea.Input) async throws -> Operations.getBuildingsForArea.Output {
        try await Task.sleep(for: .seconds(1))
        
        return .ok(
            Operations.getBuildingsForArea.Output.Ok(
                body: .json([
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building 1",
                        thumbnail: "dummy1.png",
                        keyID: "db1"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building 2",
                        thumbnail: "dummy2.png",
                        keyID: "db2"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building 3",
                        thumbnail: "dummy1.png",
                        keyID: "db3")
                ])
            )
        )
    }
    
    func getAreas(_ input: Operations.getAreas.Input) async throws -> Operations.getAreas.Output {
        return .ok(
            Operations.getAreas.Output.Ok(
                body: .json([
                    Components.Schemas.AreaModel(
                        name: Components.Schemas.AreaName.East_space_Bank,
                        thumbnail: "dummy1.png"),
                    Components.Schemas.AreaModel(
                        name: Components.Schemas.AreaName.West_space_Bank,
                        thumbnail: "dummy2.png")
                ]))
        )
    }
    
}
