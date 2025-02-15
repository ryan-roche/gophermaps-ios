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
        HStack(spacing: 4) {
            Image(systemName: "hammer.fill")
                .font(.caption2)
            Text("Development Build")
                .font(.caption)
        }
    }
}

#Preview {
    DevBuildBadge()
}
#endif
