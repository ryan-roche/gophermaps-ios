//
//  PreviewBuildingCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/5/24.
//

import SwiftUI

struct PreviewBuildingCard: View {
    let building: BuildingEntry
    
    @ScaledMetric(relativeTo: .headline) var picFrameHeight = 50
    
    var body: some View {
        HStack {
            // MARK: Name label
            // TODO: Implement "smart" truncating
            Text(building.name)
                .font(.headline)
                .fontWeight(.semibold)
                .foregroundStyle(.primary)
                .padding(.leading, 12)
            
            Spacer()
            
            // MARK: Thumbnail image
            Image(uiImage: UIImage(named: "thumbnails/\(building.thumbnail)") ?? UIImage())
                .resizable()
                .scaledToFill()
                .frame(width:120, height:picFrameHeight)
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
