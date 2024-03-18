//
//  InstructionNavigator.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/12/24.
//

import SwiftUI

struct InstructionNavigator: View {
    var route: [GraphNode]
    
    @Environment(\.dismiss) var dismiss
    
    @State var mdFileName: String
    @State var nodeIndex = 0
    
    init(route: [GraphNode]) {
        self.route = route
        self.mdFileName = route[0].nodeID + "-" + route[1].nodeID
    }
    
    var body: some View {
        ScrollView {
            InstructionFileView(filename: $mdFileName).padding(.bottom, 52)
        }.overlay(alignment: .bottom) {
            HStack {
                Button("Back") {
                    nodeIndex -= 1
                    mdFileName = route[nodeIndex].nodeID + "-" + route[nodeIndex+1].nodeID
                    print(mdFileName)
                }.buttonStyle(.borderedProminent).font(.largeTitle).disabled(nodeIndex == 0).shadow(radius:4)
                Button("Next") {
                    nodeIndex += 1
                    mdFileName = route[nodeIndex].nodeID + "-" + route[nodeIndex+1].nodeID
                    print(mdFileName)
                }.buttonStyle(.borderedProminent).font(.largeTitle).disabled(nodeIndex == route.count - 2).shadow(radius:4)
            }
        }
    }
}

#Preview {
    InstructionNavigator(route: previewShortNavRoute)
}
