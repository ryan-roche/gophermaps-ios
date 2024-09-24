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

struct AboutAppView: View {
    
    @ScaledMetric(relativeTo:.caption2) var imageSize: CGFloat = 25
    
    var body: some View {
        if let version = Bundle.main.infoDictionary?[
            "CFBundleShortVersionString"] as? String, let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
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
            
            // MARK: App version info
            HStack {
                Spacer()
                Text("Version \(version)")
                Text("•").fontWeight(.bold)
                Text("Build \(build)")
#if DEBUG
                Text("•").fontWeight(.bold)
                Text("[DEBUG]")
#endif
                Spacer()
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
            .padding(.top, 4)
        }
    }
}

#Preview {
    AboutAppView()
}
