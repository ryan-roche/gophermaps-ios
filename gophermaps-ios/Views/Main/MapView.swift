//
//  MapView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 1/29/25.
//

@preconcurrency import MapKit
import SwiftUI

struct MapView: View {
    
    #if DEBUG
    @State private var regionBounds: [MKPolygon] = []
    #endif

    var body: some View {
        Map {
            // MARK: Debug objects
            #if DEBUG
            ForEach(regionBounds, id: \.self) { polygon in
                MapPolygon(polygon)
                    .stroke(.blue)
                    .foregroundStyle(.clear)
            }
            #endif
        }
        .onAppear {
            #if DEBUG
            regionBounds = try! loadRegionBounds()
            #endif
        }
    }
}

#Preview {
    MapView()
}
