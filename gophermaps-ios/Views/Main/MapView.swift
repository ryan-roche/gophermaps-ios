//
//  MapView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 1/29/25.
//

import SwiftUI
@preconcurrency import MapKit


struct MapView: View {
    @State private var polys: [MKPolygon] = []
    
    var body: some View {
        Map() {
            ForEach(polys, id: \.self) { polygon in
                MapPolygon(polygon)
                    .stroke(.blue)
                    .foregroundStyle(.clear)
            }
        }
        .onAppear {
            loadPolygons()
        }
    }
    
    private func loadPolygons() {
        if let url = Bundle.main.url(forResource: "areaBounds", withExtension: "geojson"),
           let data = try? Data(contentsOf: url) {
            let decoder = MKGeoJSONDecoder()
            if let gjobjects = try? decoder.decode(data) {
                var newPolys: [MKPolygon] = []
                for object in gjobjects {
                    guard let feature = object as? MKGeoJSONFeature else { continue }
                    for geom in feature.geometry {
                        if let polygon = geom as? MKPolygon {
                            newPolys.append(polygon)
                        }
                    }
                }
                polys = newPolys
            }
        }
    }
}

#Preview {
    MapView()
}
