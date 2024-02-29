//
//  PreviewBuildingList.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/27/24.
//

import UIKit

var previewKellerHall = BuildingEntry(name: "Keller Hall", thumbnail: .PlaceholderBuildings.kellerHall)
var previewTateHall = BuildingEntry(name: "Tate Hall", thumbnail: .PlaceholderBuildings.tateHall)

func previewBuildings() -> [BuildingEntry] {
    previewKellerHall.destinations.insert(previewTateHall)
    previewTateHall.destinations.insert(previewKellerHall)

    let previewBuildingsList = [previewTateHall, previewKellerHall]
    return previewBuildingsList
}

func destinationPreviewBuilding() -> BuildingEntry {
    var previewBuilding = previewTateHall
    previewBuilding.destinations.insert(previewKellerHall)
    return previewBuilding
}
