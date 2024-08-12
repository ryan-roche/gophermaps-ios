//
//  AreaCard.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/11/24.
//

import SwiftUI

struct AreaCard: View {
    var body: some View {
        ZStack(alignment:.leading) {
            Image("dummy1")
                .resizable()
            VStack {
                Spacer()
                Text("Area Name")
                    .foregroundStyle(.ultraThickMaterial)
                    .fontDesign(.rounded)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(.ultraThinMaterial)
            }.compositingGroup()
        }
    }
}

#Preview {
    ZStack {
        LinearGradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)], startPoint: .top, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        AreaCard().padding()
    }
}

#Preview("List") {
    ZStack {
        LinearGradient(colors: [Color.blue.opacity(0.5), Color.purple.opacity(0.5)], startPoint: .top, endPoint: .bottomTrailing)
            .edgesIgnoringSafeArea(.all)
        VStack(spacing: 16) {
            AreaCard()
            AreaCard()
        }.padding()
    }
}
