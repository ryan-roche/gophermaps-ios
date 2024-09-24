//
//  AreaCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/11/24.
//

import Kingfisher
import SwiftUI

enum ImageCardLayoutDirection {
    case vertical
    case horizontal
}

struct ImageCard: View {
    @ScaledMetric(relativeTo: .title2) var hPicHeight = 100
        
    let label: String
    let layout: ImageCardLayoutDirection
    let imageURL: URL
    let showsChevron: Bool

    init(area: Components.Schemas.AreaModel,
         layout: ImageCardLayoutDirection = .vertical,
         showsChevron: Bool = false) {
        self.label = area.name.rawValue
        self.imageURL = URL(string: thumbnailBaseURL.appending("/areas/\(area.thumbnail)"))!
        self.layout = layout
        self.showsChevron = showsChevron
    }

    init(building: Components.Schemas.BuildingEntryModel,
         layout: ImageCardLayoutDirection = .vertical,
         showsChevron: Bool = false) {
        self.label = building.buildingName
        self.imageURL = URL(string: thumbnailBaseURL.appending("/buildings/\(building.thumbnail)"))!
        self.layout = layout
        self.showsChevron = showsChevron
    }
    
    init(label: String, imageURL: URL, layout: ImageCardLayoutDirection = .vertical, showsChevron: Bool = false) {
        self.label = label
        self.imageURL = imageURL
        self.layout = layout
        self.showsChevron = showsChevron
    }

    var body: some View {
        switch layout {
        case .vertical:
            Color.clear
                .overlay {
                    KFImage(imageURL)
                        .placeholder {
                            Rectangle()
                                .foregroundStyle(.quinary)
                                .overlay {
                                    Image(systemName:"photo")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:120)
                                        .foregroundStyle(.tertiary)
                                }
                        }
                    .resizable()
                    .scaledToFill()
                }
                .overlay(alignment: .bottom) {
                    HStack(alignment: .center) {
                        Text(label)
                            .font(.title)
                            .fontWeight(.medium)
                            .padding([.vertical, .leading])
                            .lineLimit(1)
                            .minimumScaleFactor(0.5)
                        Spacer()
                        if showsChevron {
                            Image(systemName: "chevron.forward")
                                .fontWeight(.medium)
                                .padding()
                        }
                    }
                    .foregroundStyle(.primary)
                    .background {
                        FrostedGlassView(effect: .systemMaterial, blurRadius: 4)
                            .padding([.horizontal, .bottom], -12)
                    }
                }
                .clipShape(
                    RoundedRectangle(cornerRadius: 8)
                )
        case .horizontal:
            KFImage(imageURL)
                    .resizable()
                    .scaledToFill()
                    .frame(maxWidth: .infinity, maxHeight: 100)
                    .overlay {
                        FrostedGlassView(effect: .systemMaterial, blurRadius: 4)
                            .padding(-8)
                            .clipped()
                        HStack {
                            Text(label)
                                .font(.title)
                                .fontWeight(.medium)
                            Spacer()
                            if showsChevron {
                                Image(systemName:"chevron.forward")
                                    .font(.title3)
                                    .fontWeight(.medium)
                            }
                        }.padding()
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }
}

#Preview("Area - Vertical") {
    ImageCard(
        area: Components.Schemas.AreaModel(
            name: Components.Schemas.AreaName.East_space_Bank,
            thumbnail: "EastBank.jpg"),
        showsChevron: true
    )
    .padding()
}

#Preview("Area - Horizontal") {
    ImageCard(
        area: Components.Schemas.AreaModel(
            name: Components.Schemas.AreaName.East_space_Bank,
            thumbnail: "EastBank.jpg"),
        layout: .horizontal,
        showsChevron: true
    )
    .padding()
}

#Preview("Area List - Vertical") {
    VStack(spacing: 16) {
        ImageCard(
            area: Components.Schemas.AreaModel(
                name: Components.Schemas.AreaName.East_space_Bank,
                thumbnail: "dummy1.png")
        )
        ImageCard(
            area: Components.Schemas.AreaModel(
                name: Components.Schemas.AreaName.West_space_Bank,
                thumbnail: "dummy2.png")
        )
    }.padding()
}

#Preview("Area List - Horizontal") {
    VStack(spacing: 16) {
        ImageCard(
            area: Components.Schemas.AreaModel(
                name: Components.Schemas.AreaName.East_space_Bank,
                thumbnail: "dummy1.png"),
            layout: .horizontal
        )
        ImageCard(
            area: Components.Schemas.AreaModel(
                name: Components.Schemas.AreaName.West_space_Bank,
                thumbnail: "dummy2.png"),
            layout: .horizontal
        )
    }.padding()
}

#Preview("Building - Vertical") {
    ImageCard(
        building: Components.Schemas.BuildingEntryModel(
            buildingName: "Dummy",
            thumbnail: "KellerHall.jpg",
            keyID: "db1")
    ).padding()
}
