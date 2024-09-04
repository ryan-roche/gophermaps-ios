//
//  RouteStepCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/20/24.
//
// TODO: (POLISH) Figure out a fix for text overlapping

import SwiftUI

struct RouteStepCard: View {
    let step: RouteStep
    
    var text: String {
        switch(step) {
            case .startAtFloor(let floor):
                return "**Start** on floor \(floor)"
            case .changeFloor(let floor):
                return "**Move** to floor \(floor)"
            case .changeBuilding:
                return "**Follow** signs to next building"
        }
    }
    
    var icon: String {
        switch(step) {
            case .startAtFloor:
                return "figure.walk.departure"
            case .changeFloor:
                return "figure.stairs"
            case .changeBuilding:
                return "sign.gopher-way.fill"
        }
    }
    
    func symbolImageViewWrapper() -> Image {
        if case .changeBuilding(_) = step {
            return Image(self.icon)
                .symbolRenderingMode(.hierarchical)
        } else {
            return Image(systemName: self.icon)
        }
    }
    
    init(_ step: RouteStep) { self.step = step }
    
    var body: some View {
        HStack {
            Text(try! AttributedString(markdown: self.text))
                .font(.title3)
                .padding([.leading, .vertical])
            Spacer()
        }.background {
            FrostedGlassView(effect: .systemMaterial, blurRadius: 4)
                .overlay(alignment:.trailing) {
                    symbolImageViewWrapper()
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(-3)
                        .foregroundStyle(.tertiary)
                        .mask(
                            LinearGradient(
                                colors: [
                                    .black,
                                    .black.opacity(0.5)
                                ],
                                startPoint: .bottom,
                                endPoint: .top).padding(-3)
                        )
                        .rotation3DEffect(
                            .degrees(15),
                            axis: (x: 1, y: 0, z: 0),
                            anchor: .center,
                            anchorZ: 0,
                            perspective: 1
                        )
                        .rotationEffect(.degrees(-15))
                        .offset(x: -35)
                }
        }.compositingGroup()
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

#Preview {
    RouteStepCard(.changeBuilding(method: .tunnel)).shadow(radius: 4, y:2)
        .padding(.horizontal)
    RouteStepCard(.changeFloor(to: "2")).shadow(radius: 4, y: 2).padding(.horizontal)
    RouteStepCard(.startAtFloor(to: "1")).shadow(radius: 4, y: 2).padding(.horizontal)
}
