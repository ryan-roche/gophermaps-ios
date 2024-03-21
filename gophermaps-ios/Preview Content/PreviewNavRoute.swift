//
//  PreviewNavRoute.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/29/24.
//

import UIKit

var testNode1 = BuildingEntry(name: "Test Building 1", navID: "tb1a", thumbnail: "keller-hall")
var testNode2 = GraphNode(name: "Test Building 1", navID: "tb1b")
var testNode3 = BuildingEntry(name: "Test Building 2", navID: "tb2a", thumbnail: "keller-hall")
var testNode4 = BuildingEntry(name: "Test Building 3", navID: "tb3a", thumbnail: "keller-hall")
var testNode5 = GraphNode(name: "Test Building 3", navID: "tb3b")
var testNode6 = GraphNode(name: "Test Building 3", navID: "tb3c")
var testNode7 = BuildingEntry(name: "Test Building 4", navID: "tb4a", thumbnail: "keller-hall")
var testNode8 = GraphNode(name: "Test Building 4", navID: "tb4b")
var testNode9 = BuildingEntry(name: "Test Building 5", navID: "tb5a", thumbnail: "keller-hall")

let previewShortNavRoute: [PathStep] = [testNode1, testNode3, testNode4]
let previewNavRoute: [PathStep] = [testNode1, testNode2, testNode3, testNode4, testNode5, testNode6, testNode7, testNode8, testNode9]
