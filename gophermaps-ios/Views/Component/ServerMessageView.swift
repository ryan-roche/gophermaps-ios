//
//  ServerMessageView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/9/24.
//

import SwiftUI
import MarkdownUI

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
    let model: ServerMessageModel
    let colors: [Color]
    
    init(message model: ServerMessageModel) {
        self.model = model
        self.colors = model.colorObjects
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(model.title)
                .font(.title)
                .fontWeight(.bold)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            Text(model.body).lineLimit(2).fontWeight(.semibold)
            // TODO: Show "tap for details" iff truncated
        }
        .foregroundStyle(.white)
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .multicolorGlow(colors, radius: 16)
    }
}

/// Expanded version of ServerMessageView- shows the full
/// content of the message body, including image embeds
struct ExpandedServerMessageView: View {
    let model: ServerMessageModel
    let colors: [Color]
    
    init(message model: ServerMessageModel) {
        self.model = model
        self.colors = model.colorObjects
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing:8) {
            // MARK: Header
            HStack(spacing: 0) {
                Text(model.title)
                    .font(.title)
                    .fontWeight(.bold)
                Spacer()
                Button {
                    print("tap")
                } label: {
                    Label("Minimize", systemImage:"arrow.down.right.and.arrow.up.left")
                        .labelStyle(.iconOnly)
                }
                .buttonBorderShape(.circle)
            }
            .foregroundStyle(.white)
            
            // MARK: Content
            ScrollView {
                Markdown(model.body)
                    .markdownTextStyle(\.text) {
                        ForegroundColor(.white)
                    }
                    .markdownBlockStyle(\.image) { configuration in
                        configuration.label
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                            .shadow(color: .black.opacity(0.5), radius: 8)
                    }
            }
            .padding(.vertical, 10)
            .scrollClipDisabled()
            .mask {
                VStack(spacing: 0) {
                    LinearGradient(
                        colors: [.white.opacity(0.0), .white],
                        startPoint: .top, endPoint: .bottom)
                    .frame(height: 16)
                    Color.white
                    LinearGradient(
                        colors: [.white, .white.opacity(0.0)],
                        startPoint: .top, endPoint: .bottom)
                    .frame(height: 16)
                }
            }
        }
        .padding()
        .background(LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing))
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .multicolorGlow(colors, radius: 12)
    }
}


#Preview("Short Message") {
    @Previewable let dummyMessage = ServerMessageModel(jsonString:
    """
     {
       "startDate": "2024-10-09T00:00:00-06:00",
       "endDate": "2024-10-10T00:00:00-06:00",
       "colors": [
         "#03045E",
         "#023E8A",
         "#0077B6"
       ],
       "title": "Welcome to GopherMaps!",
       "body": "We're so excited to finally launch!",
       "id": "1"
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
          "#03045E",
          "#023E8A",
          "#0077B6"
       ],
       "title": "What I do 💜",
       "body": "What would you do if when you okay so he said yes would go? Uhm... I would tell him god bless him",
       "id": "1"
     }
    """)
    
    ServerMessageView(message: dummyMessage!).padding(.horizontal)
}

#Preview("Long Message [Expanded]") {
    @Previewable let dummyMessage = ServerMessageModel(jsonString:
    """
     {
       "startDate": "2024-10-09T00:00:00-06:00",
       "endDate": "2024-10-10T00:00:00-06:00",
       "colors": [
          "#03045E",
          "#023E8A",
          "#0077B6"
       ],
       "title": "what i do 💜",
       "body": "What would you do if when you okay so he said yes would go? Uhm... I would tell him god bless him.\\n\\n ![dummy](https://i.kym-cdn.com/photos/images/newsfeed/002/436/043/938)\\n\\nI really wish that this would work but it's being quite difficult :(",
       "id": "1"
     }
    """)
    
    ExpandedServerMessageView(message: dummyMessage!).padding(.horizontal)
}
