//
//  ServerMessageView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/9/24.
//

import SwiftUI

import SwiftUI

extension View {
    func multicolorGlow(_ colors: [Color], radius: CGFloat = 20) -> some View {
        self.background {
            GeometryReader { geometry in
                ZStack {
                    ForEach(0..<2) { i in
                        Rectangle()
                            .fill(LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing))
                            .frame(width: geometry.size.width + 8, height: geometry.size.height + 8)
                            .blur(radius: radius)
                            .opacity(0.5 - Double(i) * 0.25) // Gradually decrease opacity for a softer glow
                    }
                }
                .frame(width: geometry.size.width, height: geometry.size.height)
            }
        }
    }
}


/// Displays the contents of a ServerMessage Model
/// - IMPORTANT:
///     This view does NOT check if message's date range is still valid.
///     It is assumed that that is verified before the view is instantiated
struct ServerMessageView: View {
    
    let colors: [Color]
    let title: String
    let content: String
    
    init(message model: ServerMessageModel) {
        self.title = model.title
        self.content = model.body
        self.colors = model.colorObjects
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(title).font(.title).fontWeight(.bold)
            Text(content).lineLimit(2).fontWeight(.semibold)
            // TODO: Show "tap for details" only iff truncated
        }
        .foregroundStyle(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .multicolorGlow(colors, radius: 8)
    }
}

#Preview("Short Message") {
    @Previewable let dummyMessage = ServerMessageModel(jsonString:
    """
     {
       "startDate": "2024-10-09T00:00:00-06:00",
       "endDate": "2024-10-10T00:00:00-06:00",
       "colors": [
         "#FF5733",
         "#33FF57",
         "#3357FF"
       ],
       "title": "Welcome to GopherMaps!",
       "body": "We're so excited to finally launch!"
     }
    """)
    
    ServerMessageView(message: dummyMessage!).padding(.horizontal)
}

#Preview("Long Message") {
    @Previewable let dummyMessage = ServerMessageModel(jsonString:
    """
     {
       "startDate": "2024-10-09T00:00:00-06:00",
       "endDate": "2024-10-10T00:00:00-06:00",
       "colors": [
         "#FF5733",
         "#33FF57",
         "#3357FF"
       ],
       "title": "What I do 💜",
       "body": "What would you do if when you okay so he said yes would go? Uhm... I would tell him god bless him"
     }
    """)
    
    ServerMessageView(message: dummyMessage!).padding(.horizontal)
}
