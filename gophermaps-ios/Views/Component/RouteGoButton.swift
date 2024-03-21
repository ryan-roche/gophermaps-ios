//
//  RouteGoButton.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 3/12/24.
//

import SwiftUI

struct RouteGoButtonStyle: ButtonStyle {
    var waiting: Bool
    @Environment(\.isEnabled) var isEnabled: Bool
    
    func makeBody(configuration: ButtonStyle.Configuration) -> some View {
//        let content : AnyView
//        
//        if (waiting) {
//            content = AnyView(RoundedRectangle(cornerRadius: 8)
//                .fill(LinearGradient(gradient: Gradient(colors:[Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1))]), startPoint: .bottomTrailing, endPoint: .topLeading))
//                .frame(width: 275, height: 90)
//                .shadow(color:.black.opacity(0.1), radius: 8)
//                .overlay {
//                    // TODO: replace spacing with scaledmetric
//                    HStack(spacing:16) {
//                        Text("Downloading")
//                            .font(.title)
//                            .fontWeight(.bold)
//                            .foregroundStyle(.white)
//                        ProgressView()
//                            .controlSize(.extraLarge)
//                            .tint(.white)
//                    }
//                })
//        } else if (isEnabled) {
//            content = AnyView(RoundedRectangle(cornerRadius: 8)
//                .fill(LinearGradient(gradient: Gradient(colors:[Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1))]), startPoint: .bottomTrailing, endPoint: .topLeading))
//                .frame(width: 120, height: 90)
//                .shadow(color:.black.opacity(0.1), radius: 8)
//                .overlay {
//                    // TODO: replace spacing with scaledmetric
//                    HStack(spacing:4) {
//                        Text("GO")
//                        Image(systemName: "arrow.forward")
//                    }.font(.title)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.white)
//                })
//        } else {
//            content = AnyView(RoundedRectangle(cornerRadius: 8)
//                .fill(.quinary)
//                .frame(width: 120, height: 90)
//                .shadow(color:.black.opacity(0.1), radius: 8)
//                .overlay {
//                    HStack {
//                        Text("GO")
//                        Image(systemName: "arrow.forward")
//                    }.font(.title)
//                        .fontWeight(.bold)
//                        .foregroundStyle(.tertiary)
//                })
//        }
//        
//        return content
        
        let enabledFill = LinearGradient(gradient: Gradient(colors:[Color(#colorLiteral(red: 0, green: 0.9768045545, blue: 0, alpha: 1)), Color(#colorLiteral(red: 0, green: 0.9810667634, blue: 0.5736914277, alpha: 1))]), startPoint: .bottomTrailing, endPoint: .topLeading)
        let disabledFill = HierarchicalShapeStyle.tertiary
        
        RoundedRectangle(cornerRadius:12)
            .fill(isEnabled ? AnyShapeStyle(enabledFill) : AnyShapeStyle(disabledFill))
            .frame(width: waiting ? 275 : 120, height:90)
            .overlay {
                HStack(spacing: waiting ? 16 : 4) {
                    Text(waiting ? "Downloading" : "GO")
                    if waiting {
                        ProgressView()
                    } else {
                        Image(systemName: "arrow.forward")
                    }
                }.foregroundStyle(isEnabled ? .white : .gray)
            }.font(.title).fontWeight(.bold)
    }
}

struct RouteGoButton: View {
    var onTap: () async -> Void
    @State var waiting = false
    
    var body: some View {
        Button("foo") {
            Task {
                await onTap()
                withAnimation {
                    waiting = false
                }
            }
            withAnimation {
                waiting = true
            }
        }.buttonStyle(RouteGoButtonStyle(waiting: waiting))
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var downloading = false
        var body: some View {
            RouteGoButton(onTap: {
                await Backend.downloadRouteData(route: [])
            })
            RouteGoButton(onTap: {
                await Backend.downloadRouteData(route: [])
            }).disabled(true)
        }
    }
    return PreviewWrapper()
}
