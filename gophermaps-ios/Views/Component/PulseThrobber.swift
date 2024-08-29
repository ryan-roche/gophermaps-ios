//
//  SwiftUIView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/14/24.
//
// TODO: Implement this (non-MVP)

import SwiftUI

struct PulseThrobber: View {
    let textLabel: String
    
    var body: some View {
        ProgressView(textLabel)
        Text(textLabel)
            .foregroundStyle(.secondary)
    }
    
    init(_ text: String) {
        self.textLabel = text
    }
}

#Preview {
    PulseThrobber("test string")
}
