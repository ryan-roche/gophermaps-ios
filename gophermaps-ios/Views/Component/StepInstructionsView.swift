//
//  StepInstructionsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/1/24.
//

import SwiftUI

struct StepInstructionsView: View {
    
    let step: RouteStep
    
    init(_ step: RouteStep) {
        self.step = step
    }
    
    var body: some View {
        switch step {
            case .changeBuilding(_, _, let startID, let endID):
                InstructionsMarkdownView(dirName: "\(startID)-\(endID)")
            default:
                LoadingView(symbolName: "exclamationmark.triangle", label: "Incorrect Step Type!")
        }
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
