//
//  MockAPIClient.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/12/24.
//

import Foundation

struct MockAPIClient: APIProtocol {
    
    func getRoute(_ input: Operations.getRoute.Input) async throws -> Operations.getRoute.Output {
        return .ok(
            Operations.getRoute.Output.Ok(
                body: .json([
                    Components.Schemas.NavigationNodeModel(
                        buildingName: "Dummy 1",
                        floor: "1",
                        navID: "db1"),
                    Components.Schemas.NavigationNodeModel(
                        buildingName: "Dummy 1",
                        floor: "2",
                        navID: "db1a"),
                    Components.Schemas.NavigationNodeModel(
                        buildingName: "Dummy 2",
                        floor: "3",
                        navID: "db2"),
                    Components.Schemas.NavigationNodeModel(
                        buildingName: "Dummy 3",
                        floor: "3",
                        navID:" db3")
                ])
            )
        )
    }
    
    func getDestinationsForBuilding(_ input: Operations.getDestinationsForBuilding.Input) async throws -> Operations.getDestinationsForBuilding.Output {
        return .ok(
            Operations.getDestinationsForBuilding.Output.Ok(
                body: .json([
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building",
                        thumbnail: "dummy1.png",
                        navID: "db1"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building",
                        thumbnail: "dummy2.png",
                        navID: "db2"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building",
                        thumbnail: "dummy3.png",
                        navID: "db3"),
                ])
            )
        )
    }
    
    func getBuildingsForArea(_ input: Operations.getBuildingsForArea.Input) async throws -> Operations.getBuildingsForArea.Output {
        return .ok(
            Operations.getBuildingsForArea.Output.Ok(
                body: .json([
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building 1",
                        thumbnail: "dummy1.png",
                        navID: "db1"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building 2",
                        thumbnail: "dummy2.png",
                        navID: "db2"),
                    Components.Schemas.BuildingEntryModel(
                        buildingName: "Dummy Building 3",
                        thumbnail: "dummy3.png",
                        navID: "db3")
                ])
            )
        )
    }
    
    func getAreas(_ input: Operations.getAreas.Input) async throws -> Operations.getAreas.Output {
        return .ok(
            Operations.getAreas.Output.Ok(
                body: .json([
                    Components.Schemas.AreaModel(
                        name: Components.Schemas.AreaModel.namePayload.init(value1: .EastBank),
                        thumbnail: "dummy1.png")
                ]))
        )
    }
    
    
}
