//
//  HapticTests.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 11/5/24.
//

import SwiftUI

struct HapticTestsView: View {
    @State private var startTrigger = false
    @State private var stopTrigger = false
    @State private var successTrigger = false
    @State private var errorTrigger = false
    @State private var warningTrigger = false
    
    var body: some View {
        VStack {
            Button("Start") { startTrigger.toggle() }
                .sensoryFeedback(.start,
                                 trigger: startTrigger)
            Button("Stop") { stopTrigger.toggle() }
                .sensoryFeedback(.stop,
                                 trigger: stopTrigger)
            Button("Success") { successTrigger.toggle() }
                .sensoryFeedback(.success,
                                 trigger: successTrigger)
            Button("Error") { errorTrigger.toggle() }
                .sensoryFeedback(.error,
                                 trigger: errorTrigger)
            Button("Warning") { warningTrigger.toggle() }
                .sensoryFeedback(.warning,
                                 trigger: warningTrigger)
        }
        .font(.title)
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    HapticTestsView()
}
