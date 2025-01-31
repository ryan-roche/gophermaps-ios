//
//  AreaSelector.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 1/29/25.
//

import SwiftUI

struct AreaSelector: View {
    @State private var selectedArea: Components.Schemas.AreaName
    
    init() {
        selectedArea = .East_space_Bank
    }
    
    var body: some View {
        Picker("Area", selection: $selectedArea) {
            ForEach(Components.Schemas.AreaName.allCases, id: \.rawValue) { area in
                Text(area.rawValue).tag(area)
            }
        } currentValueLabel: {
            // TODO: Replace with "chip"
            Text(selectedArea.rawValue)
        }
        .buttonStyle(.bordered)
    }
}

#Preview {
    AreaSelector()
}
