//
//  BuildingListEntry.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/27/24.
//

import SwiftUI

struct BuildingEntry: Hashable {
    let name: String
    let thumbnail: ImageResource
    
    var destinations = Set<BuildingEntry>()
}
