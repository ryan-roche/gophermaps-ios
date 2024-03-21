//
//  BuildingListEntry.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/27/24.
//

import SwiftUI

// Represents the nodes in the graph database with the BuildingKey label
struct BuildingEntry: Hashable, Codable, PathStep {
    let name: String
    let navID: String
    let thumbnail: String
}
