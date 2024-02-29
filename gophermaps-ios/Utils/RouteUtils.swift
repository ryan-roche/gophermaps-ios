//
//  RouteUtils.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/29/24.
//

import UIKit

func getBuildingsFromRoute(route: [GraphNode]) -> [BuildingEntry] {
    var buildingList: [BuildingEntry] = []
    var uniqueBuildings = Set<String>()
    
    for node in route {
        if !uniqueBuildings.contains(node.building.name) {
            buildingList.append(node.building)
            uniqueBuildings.insert(node.building.name)
        }
    }
    
    return buildingList
}
