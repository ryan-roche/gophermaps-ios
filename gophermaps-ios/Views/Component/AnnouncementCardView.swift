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

@ViewBuilder func announcementBadge() -> some View {
    HStack(alignment: .center, spacing: 6) {
        Image(systemName: "megaphone")
            .font(.footnote)
        Text("announcement")
            .font(Font.system(.footnote).smallCaps())
    }
    .foregroundStyle(.primary)
    .padding(4)
    .overlay {
        RoundedRectangle(cornerRadius: 4).stroke(.primary, lineWidth: 1)
    }
}

/// Displays the contents of a ServerMessage Model
/// - IMPORTANT:
///     This view does NOT check if message's date range is still valid.
///     It is assumed that that is verified before the view is instantiated
struct AnnouncementCardView: View {
    
    @Namespace private var announcementCardNamespace
    
    @Binding var showing: Bool
    
    let model: ServerMessageModel
    let colors: [Color]
    
    init(message model: ServerMessageModel, isShowing: Binding<Bool>) {
        self.model = model
        self.colors = model.colorObjects
        self._showing = isShowing
    }
    
    var body: some View {
        NavigationLink {
            AnnouncementDetailsView(message: model) {
                withAnimation(.snappy) {                
                    showing.toggle()
                }
            }
                .navigationTransition(.zoom(sourceID: "card", in: announcementCardNamespace))
        } label: {
            cardBody(model) {
                withAnimation(.snappy) {
                    showing.toggle()
                }
            }
                .matchedTransitionSource(id: "card", in: announcementCardNamespace)
        }
    }
}

private struct cardBody: View {
    
    let model: ServerMessageModel
    let colors: [Color]
    let dismissCallback: () -> Void
    
    init(_ model: ServerMessageModel, dismissCallback: @escaping () -> Void) {
        self.model = model
        self.colors = model.colorObjects
        self.dismissCallback = dismissCallback
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            // MARK: Announcement Badge
            HStack(alignment: .bottom) {
                announcementBadge()
                Spacer()
            }
            
            // MARK: Message Title
            Text(model.title)
                .font(.title2)
                .fontWeight(.bold)
                .multilineTextAlignment(.leading)
                .padding(.top, 8)
                .padding(.bottom, 2)
            
            // MARK: Disclosure Prompt
            HStack(alignment: .center) {
                Text("Read More")
                Image(systemName: "chevron.forward")
            }.font(.subheadline).opacity(0.8)
        }
        .foregroundStyle(.white)
        .padding()
        .background {
            LinearGradient(gradient: Gradient(colors: colors), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
        .clipShape(RoundedRectangle(cornerRadius: 16))
        
        // MARK: Dismiss Button
        .overlay(alignment: .topTrailing) {
            dismissButton {
                dismissCallback()
            }
            .shadow(color: .black.opacity(0.15), radius: 4, y:2)
            .padding([.top, .trailing], 14)
        }
    }
}

private struct dismissButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            HStack(alignment: .center) {
                Text("Dismiss")
                    .font(.body.smallCaps())
                    .baselineOffset(2)
                Image(systemName: "xmark")
                    .font(.body)
                    .font(.body.smallCaps())
            }
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .blendMode(.destinationOut)
            .background(Capsule().fill(.regularMaterial))
            .compositingGroup()
        }
    }
}

#Preview("Short Message") {
    @Previewable @State var isShowing = true
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
    
    NavigationStack {
        if isShowing {
            AnnouncementCardView(message: dummyMessage!,
                                 isShowing: $isShowing)
            .padding(.horizontal)
        } else {
            Button("Show Card") {
                isShowing.toggle()
            }
        }
    }
    
}

#Preview("Long Message") {
    @Previewable @State var isShowing = true
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
       "body": "What would you do if when you okay so he said yes would go? Uhm... I would tell him god bless him.\\n\\n ![dummy](https://i.kym-cdn.com/photos/images/newsfeed/002/436/043/938)\\n\\nfiller filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler filler",
       "id": "1"
     }
    """)
    
    NavigationStack {
        if isShowing {
            AnnouncementCardView(message: dummyMessage!,
                                 isShowing: $isShowing)
            .padding(.horizontal)
        } else {
            Button("Show Card") {
                isShowing.toggle()
            }
        }
    }
    
}
