//
//  KeyBuildingBadge.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/19/24.
//
// TODO: Animate "pulsing" (non-MVP)

import SwiftUI

enum BuildingBadgeType {
    case start
    case end
    
    var label: String {
        switch(self) {
            case .start:
                return "Route Start"
            case .end:
                return "Destination"
        }
    }
    
    var icon: String {
        switch(self) {
            case .start:
                return "arrowtriangle.forward.fill"
            case .end:
                return "flag.checkered"
        }
    }
}

struct KeyBuildingBadge: View {
    let type: BuildingBadgeType
    
    init(_ type: BuildingBadgeType) {
        self.type = type
    }
    
    var body: some View {
        Label(type.label, systemImage: type.icon)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(10)
            .background {
                FrostedGlassView(effect: .systemMaterial, blurRadius: 4)
            }.clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    KeyBuildingBadge(.start)
    KeyBuildingBadge(.end)
}
