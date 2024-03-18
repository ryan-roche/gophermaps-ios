//
//  BuildingCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/26/24.
//

import SwiftUI

struct MenuBuildingCard: View {
    let building: BuildingEntry
    let smallText: Bool
    
    @ScaledMetric(relativeTo: .title3) var picFrameHeight = 70
    
    init(building: BuildingEntry, smallText: Bool) {
        self.building = building
        self.smallText = smallText
    }
    
    init(building: BuildingEntry) {
        self.building = building
        self.smallText = false
    }
    
    var body: some View {
        HStack {
            // MARK: Name label
            // TODO: Implement "smart" truncating
            Text(building.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.leading, 12)
                .padding(.vertical, 20)
            
            Spacer()
            
            // MARK: Thumbnail image
            Image(building.thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width:150, height:picFrameHeight)
        }.background(.thickMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 6))
            
    }
}

#Preview {
    VStack{
        MenuBuildingCard(building: previewKellerHall)
        PreviewBuildingCard(building: previewKellerHall)
    }.padding(.horizontal)
}
