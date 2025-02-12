//
//  SavedRouteModel.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 9/12/24.
//

import Foundation
import SwiftData

@Model
class SavedRoute: CustomStringConvertible {
    var start: Components.Schemas.BuildingEntryModel
    var end: Components.Schemas.BuildingEntryModel
    
    var description: String {
        return "\(start.keyID) -> \(end.keyID)"
    }
    
    init(start: Components.Schemas.BuildingEntryModel, end: Components.Schemas.BuildingEntryModel) {
        self.start = start
        self.end = end
    }
}

#if DEBUG
@MainActor let sampleRoutes: [SavedRoute] = [
    SavedRoute(start: .init(buildingName: "Keller Hall", thumbnail: "KellerHall.jpg", keyID: "kh4"),
               end: .init(buildingName: "Walter Library", thumbnail: "Walter.jpg", keyID: "waltB")),
    SavedRoute(start: .init(buildingName: "Keller Hall", thumbnail: "KellerHall.jpg", keyID: "kh4"),
               end: .init(buildingName: "Tate Hall", thumbnail: "TateHall.jpg", keyID: "thSB")),
    SavedRoute(start: .init(buildingName: "Walter Library", thumbnail: "Walter.jpg", keyID: "waltB"),
               end: .init(buildingName: "Tate Hall", thumbnail: "TateHall.jpg", keyID: "thSB")),
    SavedRoute(start: .init(buildingName: "Mechanical Engineering", thumbnail: "MechEng.jpg", keyID: "me2"),
               end: .init(buildingName: "Smith Hall", thumbnail: "Smith.jpg", keyID: "smthB"))
]

@MainActor
let previewContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: SavedRoute.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        for route in sampleRoutes {
            container.mainContext.insert(route)
        }
        return container
    } catch {
        fatalError("Failed to create preview container: \(error)")
    }
}()

let previewEmptyContainer: ModelContainer = {
    do {
        let container = try ModelContainer(for: SavedRoute.self, configurations: ModelConfiguration(isStoredInMemoryOnly: true))
        return container
    } catch {
        fatalError("Failed to create empty preview container: \(error)")
    }
}()
#endif
