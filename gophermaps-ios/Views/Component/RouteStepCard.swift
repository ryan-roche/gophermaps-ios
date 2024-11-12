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
    
    @State var hasInstructions = false
    @State var flashingPrompt = false
    
    @Namespace var cardTransition
    
    // Used when the step has detailed instructions available
    @State var showingInstructions = false
    @State var instructionDownloadStatus: DownloadStatus?
    let startID: String?
    let endID: String?
    
    // Used for haptic feedback
    @State var successHapticTrigger = false
    @State var errorHapticTrigger = false
    @State var genericImpactTrigger = false
    
    init(_ step: RouteStep) {
        self.step = step
        switch step {
            case .startAtFloor:
                self.startID = nil
                self.endID = nil
            case .changeFloor(_, _, let startID, let endID),
                .changeBuilding(_, _, let startID, let endID):
                self.startID = startID
                self.endID = endID
        }
    }
    
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
    
    func beginDownloadingInstructions() {
        instructionDownloadStatus = .waiting
        Task {
            do {
                try await DownloadManager.shared.downloadInstructions(from: "\(startID!)-\(endID!)")
                instructionDownloadStatus = try await DownloadManager.shared.getInstructionStatus(for: "\(startID!)-\(endID!)")
                if case .downloaded = instructionDownloadStatus { successHapticTrigger.toggle()
                }
            } catch {
                instructionDownloadStatus = .failed(error as! DownloadFailure)
                errorHapticTrigger.toggle()
            }
        }
    }
    
    func handleButtonTap() {
        genericImpactTrigger.toggle()
        
        if hasInstructions {
            switch instructionDownloadStatus! {
                case .unavailable:
                    print("This shouldn't be reachable!!")
                case .missing, .failed(_):
                    beginDownloadingInstructions()
                case .downloaded:
                    showingInstructions = true
                case .waiting:
                    return    // Do nothing if already downloading
            }
        }
    }
    
    @ViewBuilder func buttonPrompt() -> some View {
        switch instructionDownloadStatus! {
            case .unavailable:
                Label("Instructions Unavailable", systemImage: "xmark")
            case .missing:
                Label("Tap to Download Instructions", systemImage: "arrow.down.circle.dotted")
                    .foregroundStyle(.blue)
            case .waiting:
                HStack {
                    ProgressView()
                    Text("Downloading Instructions...")
                }
            case .downloaded:
                HStack {
                    Text("Tap to View Instructions")
                    Image(systemName: "chevron.forward")
                        .font(.caption)
                }
                .foregroundStyle(flashingPrompt ? .green : .secondary)
                .onAppear {
                    flashingPrompt = true
                    withAnimation(.snappy(duration: 1.5)) {
                        flashingPrompt = false
                    }
                }
            case .failed(_):
                Label("Download Failed • Tap to Retry", systemImage: "exclamationmark.triangle.fill")
                    .foregroundStyle(flashingPrompt ? .red : .secondary)
                    .onAppear {
                        flashingPrompt = true
                        withAnimation(.snappy(duration: 1.5)) {
                            flashingPrompt = false
                        }
                    }
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
        Button {
            // There's a lot going on with this, so I'm moving it to a separate function for readibility
            handleButtonTap()
        } label: {
            VStack {
                mainContent()
                    .shadow(color:.black.opacity(hasInstructions ? 0.15 : 0), radius:2, y: 2)
                
                if hasInstructions {
                    HStack {
                        buttonPrompt()
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
                if hasInstructions {
                    FrostedGlassView(effect: .systemThinMaterial, blurRadius: 4)
                        .background(.quaternary)
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
            }
            .compositingGroup()
            .shadow(color:.black.opacity(0.2), radius:4, y: 4)
        }
        .buttonStyle(.plain)
        .sensoryFeedback(.success, trigger: successHapticTrigger)
        .sensoryFeedback(.error, trigger: errorHapticTrigger)
        .sensoryFeedback(.impact(flexibility: .solid), trigger: genericImpactTrigger)
        .task {
            // Verifies that hasInstructions is correct, and sets instructionsDownloadStatus to the appropriate value if true
            switch step {
                case .startAtFloor:
                    break   // hasInstructions remains false
                case .changeFloor(_, let boolVal, _, _),
                     .changeBuilding(_, let boolVal, _, _):
                    
                    if boolVal {
                        do {
                            self.instructionDownloadStatus = try await DownloadManager.shared.getInstructionStatus(for: "\(startID!)-\(endID!)")
                            
                            // Database might have false-positive values for links with instructions, so double-check that they're available
                            if case .unavailable = self.instructionDownloadStatus {
                                print("Instructions unavailable in manifest, but reported available in database for \(startID!)-\(endID!)")
                                break
                            }
                            
                            // If all previous checks pass, then we can be certain that instructions ARE available
                            self.hasInstructions = true
                            
                        } catch {
                            print("Failed to verify instruction status: \(error.localizedDescription)")
                            break
                        }
                    }
            }
        }
        .navigationDestination(isPresented: $showingInstructions, destination: {StepInstructionsView(step)})
    }
}

#Preview {
    NavigationStack {
        VStack(spacing: 32) {
            RouteStepCard(.changeBuilding(method: .tunnel, hasInstructions: true, startID:"kh4", endID:"me2"))
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
