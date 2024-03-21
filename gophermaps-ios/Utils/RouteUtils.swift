//
//  RouteUtils.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/29/24.
//

import UIKit

func getBuildingsFromRoute(route: [any PathStep]) -> [BuildingEntry] {
    return route.compactMap { $0 as? BuildingEntry }
}
