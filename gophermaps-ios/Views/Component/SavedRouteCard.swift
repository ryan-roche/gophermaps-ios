//
//  SavedRouteCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 9/12/24.
//

import SwiftUI
import Kingfisher

struct SavedRouteCard: View {
    let route: SavedRoute
    
    init(_ route: SavedRoute) {
        self.route = route
    }
    
    var body: some View {
        HStack(spacing:0) {
            
            Color.clear
                .overlay {
                    KFImage(URL(string: thumbnailBaseURL.appending("/buildings/\(route.start.thumbnail)"))!)
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
                }.clipped()
            
            Color.clear
                .overlay {
                    KFImage(URL(string: thumbnailBaseURL.appending("/buildings/\(route.end.thumbnail)"))!)
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
                }.clipped()
            
        }
        .overlay {
            FrostedGlassView(effect: .systemMaterial, blurRadius: 4)
                .padding(-8)
                .clipped()
            HStack(spacing:0) {
                Text(route.start.buildingName)
                    .frame(maxWidth: .infinity, alignment: .center)

                Group {
                    Divider()
                        .overlay {
                            Image(systemName:"arrow.forward")
                                .padding(8)
                                .background {
                                    Circle()
                                        .fill(.black.blendMode(.destinationOut))
                                        .stroke(.tertiary, lineWidth: 1)
                                }
                                .font(.headline)
                        }
                }.compositingGroup()
                    .padding(.horizontal, 24)
                
                Text(route.end.buildingName)
                    .frame(maxWidth: .infinity, alignment: .center)

            }
            .font(.title)
            .fontWeight(.medium)
            .padding(.horizontal, 20)
            .padding(.trailing, 6)
            .minimumScaleFactor(0.5)
            .lineLimit(2)
            .multilineTextAlignment(.center)
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    SavedRouteCard(SavedRoute(start: .init(buildingName: "Keller Hall", thumbnail: "KellerHall.jpg", keyID: "kh4"),
                              end: .init(buildingName: "Walter Library", thumbnail: "Walter.jpg", keyID: "waltB")))
    .frame(height:120)
    .overlay {
        HStack {
            Spacer()
            Image(systemName:"chevron.forward")
                .padding(.trailing, 8)
        }
    }
    .padding(.horizontal)
}
