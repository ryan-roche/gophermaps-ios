//
//  StepInstructionsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/1/24.
//

import SwiftUI

struct StepInstructionsView: View {
    
    @State private var vm: InstructionsViewModel
    
    init(_ step: RouteStep) {
        switch step {
            case .changeBuilding:
                self.vm = InstructionsViewModel(step)
            default:
                fatalError("Incorrect RouteStep type: \(step)")
        }
    }
    
    var body: some View {
        switch vm.status {
            case .idle:
                Color.clear.onAppear {
                    Task {
                        do {
                            try await vm.loadInstructions()
                        } catch {
                            vm.status = .failed
                        }
                    }
                    vm.status = .loading
                }
            case .loading:
                LoadingView(symbolName:"arrow.down.document", label: "Downloading Instructions...")
                    .symbolEffect(.pulse, isActive: true)
            case .done:
                Text("DUMMY")
            case .failed:
                ContentUnavailableView("Failed to download instructions.", image: "arrow.down.app.dashed.trianglebadge.exclamationmark")
            case .offline:
                NetworkOfflineMessage()
        }
    }
}

@Observable class InstructionsViewModel {
    let step: RouteStep
    var status: apiCallState = .idle
    
    init(_ step: RouteStep) {
        self.step = step
    }
    
    @MainActor
    func loadInstructions() async throws {
        return
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
