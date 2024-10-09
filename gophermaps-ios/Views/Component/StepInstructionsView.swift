//
//  StepInstructionsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/1/24.
//

import SwiftUI

struct StepInstructionsView: View {
    
    let instructionsDirName: String
    
    init(_ step: RouteStep) {
        guard case let RouteStep.changeBuilding(_, true, start, end) = step else {
            fatalError("Incorrect step type!")
        }
        
        instructionsDirName = start + "-" + end
    }
    
    var body: some View {
        InstructionsMarkdownView(dirName: instructionsDirName)
    }
}

#Preview {
    @Previewable let step = RouteStep.changeBuilding(
        method: .skyway,
        hasInstructions: true,
        startID: "kh4",
        endID: "me2")
    
    StepInstructionsView(step)
}
