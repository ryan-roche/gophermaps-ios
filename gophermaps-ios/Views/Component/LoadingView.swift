//
//  LoadingView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/2/24.
//

import SwiftUI

struct LoadingView: View {
    let symbolName: String
    let label: String
    
    init(symbolName: String, label: String) {
        self.symbolName = symbolName
        self.label = label
    }
    
    var body: some View {
        VStack {
            Image(systemName:symbolName)
                .resizable()
                .scaledToFit()
                .foregroundStyle(.tertiary)
                .frame(width:100, height:100)
            HStack {
                ProgressView()
                Text(label).foregroundStyle(.secondary)
            }
            .padding()
        }
    }
}

#Preview {
    LoadingView(symbolName: "map", label: "Loading...")
        .symbolEffect(.pulse, isActive: true)
}
