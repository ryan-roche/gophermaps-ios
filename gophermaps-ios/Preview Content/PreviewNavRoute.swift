//
//  PreviewNavRoute.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/29/24.
//

import UIKit

var testBuilding1 = BuildingEntry(name: "Test Building 1", thumbnail: .PlaceholderBuildings.kellerHall)
var testBuilding2 = BuildingEntry(name: "Test Building 2", thumbnail: .PlaceholderBuildings.kellerHall)
var testBuilding3 = BuildingEntry(name: "Test Building 3", thumbnail: .PlaceholderBuildings.kellerHall)
var testBuilding4 = BuildingEntry(name: "Test Building 4", thumbnail: .PlaceholderBuildings.kellerHall)
var testBuilding5 = BuildingEntry(name: "Test Building 5", thumbnail: .PlaceholderBuildings.kellerHall)

var testNode1 = GraphNode(nodeID: "tb1a", building: testBuilding1)
var testNode2 = GraphNode(nodeID: "tb1b", building: testBuilding1)
var testNode3 = GraphNode(nodeID: "tb2a", building: testBuilding2)
var testNode4 = GraphNode(nodeID: "tb3a", building: testBuilding3)
var testNode5 = GraphNode(nodeID: "tb3b", building: testBuilding3)
var testNode6 = GraphNode(nodeID: "tb3c", building: testBuilding3)
var testNode7 = GraphNode(nodeID: "tb4a", building: testBuilding4)
var testNode8 = GraphNode(nodeID: "tb4b", building: testBuilding4)
var testNode9 = GraphNode(nodeID: "tb5a", building: testBuilding5)

let previewShortNavRoute = [testNode1, testNode3, testNode4]

func previewNavRoute() -> [GraphNode] {
    return [testNode1, testNode2, testNode3, testNode4, testNode5, testNode6, testNode7, testNode8, testNode9]
}
