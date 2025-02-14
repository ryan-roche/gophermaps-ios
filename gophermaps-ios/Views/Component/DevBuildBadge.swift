//
//  DevBuildBadge.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/14/25.
//
#if DEBUG
import SwiftUI

struct DevBuildBadge: View {
    var body: some View {
        Label("Dev Build", systemImage: "hammer.fill")
            .padding()
            .background(
                FrostedGlassView(effect: .systemChromeMaterial)
                    .clipShape(Capsule(style:.circular))
                    .shadow(color:.black.opacity(0.25), radius: 4, y:2)
            )
    }
}

#Preview {
    DevBuildBadge()
}
#endif
