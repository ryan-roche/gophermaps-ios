//
//  BuildingLoader.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 1/31/25.
//

import Foundation
import MapKit

func loadBuildingMarkers(area: Components.Schemas.AreaModel) {
    return
}


// MARK: Debug functions

#if DEBUG
enum RegionBoundsError: Error {
    case fileNotFound
    case invalidData
    case decodingError
}

func loadRegionBounds() throws -> [MKPolygon] {
    guard let url = Bundle.main.url(forResource: "areaBounds", withExtension: "geojson") else {
        throw RegionBoundsError.fileNotFound
    }
    
    let data: Data
    do {
        data = try Data(contentsOf: url)
    } catch {
        throw RegionBoundsError.invalidData
    }
    
    let decoder = MKGeoJSONDecoder()
    let gjobjects: [Any]
    do {
        gjobjects = try decoder.decode(data)
    } catch {
        throw RegionBoundsError.decodingError
    }
    
    var newPolys: [MKPolygon] = []
    for object in gjobjects {
        guard let feature = object as? MKGeoJSONFeature else {
            continue
        }
        for geom in feature.geometry {
            if let polygon = geom as? MKPolygon {
                newPolys.append(polygon)
            }
        }
    }
    
    return newPolys
}
#endif
