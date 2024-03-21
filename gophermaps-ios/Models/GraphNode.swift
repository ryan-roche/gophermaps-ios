//
//  GraphNode.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/29/24.
//

import SwiftUI

struct GraphNode: Codable, Hashable, PathStep {
    let name: String    // The name of the building the GraphNode belongs to
    let navID: String   // The unique string identifier of the specific node
}
