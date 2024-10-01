//
//  AboutAppView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 8/20/24.
//
// TODO: (POLISH) Fix size of info cards
// TODO: (POLISH) Switch to WebView instead of Link

import SwiftUI
import Kingfisher

struct ProfileCards: View {
    
    @ScaledMetric(relativeTo:.caption2) var imageSize: CGFloat = 40
    
    var body: some View {
        HStack {
            // MARK: Developer Profile Card
            Link(destination: URL(string:"https://github.com/ryan-roche")!) {
                HStack {
                    KFImage(URL(string: "https://github.com/ryan-roche.png"))
                        .resizable()
                        .scaledToFit()
                        .frame(height:imageSize)
                        .clipShape(Circle())
                    VStack(alignment:.leading, spacing:0) {
                        Text("Developed by")
                            .fontWeight(.light)
                            .font(.caption2)
                        Text("Ryan Roche")
                            .fontWeight(.semibold)
                            .font(.caption)
                    }
                }
                .padding(8)
                .background {
                    FrostedGlassView(effect: .systemMaterial, blurRadius:4)
                }.clipShape(RoundedRectangle(cornerRadius:8))
                    .shadow(color: .black.opacity(0.2), radius:2)
            }.buttonStyle(.plain)
            
            // MARK: Social Coding Info Card
            Link(destination: URL(string:"https://socialcoding.net")!) {
                HStack {
                    Image("SocialCodingLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width:imageSize, height:imageSize)
                    VStack(alignment:.leading, spacing:0) {
                        Text("With help from")
                            .fontWeight(.light)
                            .font(.caption2)
                        Text("Social Coding")
                            .fontWeight(.semibold)
                            .font(.caption2)
                    }
                }
                .padding(8)
                .background {
                    FrostedGlassView(effect: .systemMaterial, blurRadius:4)
                }.clipShape(RoundedRectangle(cornerRadius:8))
                    .shadow(color: .black.opacity(0.2), radius:2)
            }.buttonStyle(.plain)
        }
    }
}

#Preview {
    ProfileCards()
}
