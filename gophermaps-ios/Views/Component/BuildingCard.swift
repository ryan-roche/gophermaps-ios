//
//  BuildingCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/26/24.
//

import SwiftUI

struct BuildingCard: View {
    let building: BuildingEntry
    @ScaledMetric(relativeTo: .title3) var picFrameHeight = 70
    
    var body: some View {
        HStack {
            Text(building.name)
                .font(.title3)
                .fontWeight(.bold)
                .padding(.leading, 12)
                .padding(.vertical, 20)
            
            Spacer()
            
            Image(building.thumbnail)
                .resizable()
                .scaledToFill()
                .frame(width:150, height:picFrameHeight)
                .clipped()
        }.background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: 6))
            .shadow(color:Color.black.opacity(0.2),radius: 8, y:6)
            .padding(.horizontal)
            
    }
}

#Preview {
    BuildingCard(building: previewKellerHall)
}
