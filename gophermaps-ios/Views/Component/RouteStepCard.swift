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
    
    init(_ step: RouteStep) { self.step = step }
    
    var text: String {
        switch(step) {
            case .startAtFloor(let floor):
                return "**Start** on floor \(floor)"
            case .changeFloor(let floor, _, _, _):
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
        if case .changeBuilding(_, _, _, _) = step {
            return Image(self.icon)
                .symbolRenderingMode(.hierarchical)
        } else {
            return Image(systemName: self.icon)
        }
    }
    
    func hasInstructions() -> Bool {
        switch step {
            case .startAtFloor:
                return false
            case .changeFloor(_, let boolVal, _, _),
                 .changeBuilding(_, let boolVal, _, _):
                return boolVal
        }
    }
    
    @ViewBuilder private func mainContent() -> some View {
        HStack {
            Text(try! AttributedString(markdown: self.text))
                .font(.title3)
                .padding([.leading, .vertical])
            Spacer()
        }.background {
            FrostedGlassView(effect: .systemThickMaterial, blurRadius: 8)
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
                                    .black.opacity(0.4)
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
                        .offset(x: -15)
                }
        }
        .compositingGroup()
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
    
    var body: some View {
        VStack {
            mainContent()
                .shadow(color:.black.opacity(hasInstructions() ? 0.15 : 0), radius:2, y: 2)
            
            if hasInstructions() {
                HStack {
                    Text("Tap for instructions")
                    Image(systemName: "chevron.forward")
                        .font(.caption)
                    Spacer()
                }
                .foregroundStyle(.secondary)
                .padding(.horizontal)
                .padding(.bottom, 8)
                .compositingGroup()
            }
            
        }
        .background {
            // Couldn't find a more graceful way of doing this- prevents
            // a "double stacked" background when no instructions available
            if hasInstructions() {
                FrostedGlassView(effect: .systemThinMaterial, blurRadius: 4)
                    .background(.quaternary)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
        .compositingGroup()
        .shadow(color:.black.opacity(0.2), radius:4, y: 4)
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 32) {
            RouteStepCard(.changeBuilding(method: .tunnel, hasInstructions: true, startID:"foo", endID:"bar"))
                .padding(.horizontal)
                .padding(.horizontal)
            
            RouteStepCard(.changeBuilding(method: .tunnel, hasInstructions: false, startID:"foo", endID:"bar"))
                .padding(.horizontal)
                .padding(.horizontal)
            
            RouteStepCard(.changeFloor(to: "2", hasInstructions: false, startID:"foo", endID:"bar"))
                .padding(.horizontal)
                .padding(.horizontal)
            
            RouteStepCard(.startAtFloor(to: "1"))
                .padding(.horizontal)
                .padding(.horizontal)
        }
    }
}
