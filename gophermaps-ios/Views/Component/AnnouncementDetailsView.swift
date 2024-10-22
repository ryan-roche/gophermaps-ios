//
//  AnnouncementDetailsView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/21/24.
//

import SwiftUI
import MarkdownUI

struct AnnouncementDetailsView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    let model: ServerMessageModel
    let colors: [Color]
    
    let dismissCallback: () -> Void
    
    init(message model: ServerMessageModel, dismissCallback: @escaping () -> Void) {
        self.model = model
        self.colors = model.colorObjects
        self.dismissCallback = dismissCallback
    }
    
    var body: some View {
        VStack {
            // MARK: Buttons
            HStack(alignment:.center) {
                Spacer()
                dismissButton() {
                    dismiss()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.65) {
                        // Ensures the minimizing animation completes before the message gets dismissed
                        dismissCallback()
                    }
                }
                .padding(.trailing, 4)
                minimizeButton() {
                    dismiss()
                    // dismisses the view in the SwiftUI sense - in other words, it minimizes it.
                }
            }.shadow(color: .black.opacity(0.15), radius: 4, y:2)
                .padding(.top, 4)
            
            // MARK: Header
            HStack {
                VStack(alignment: .leading) {
                    announcementBadge()
                    Text(model.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                        .padding(.bottom, 2)
                }
                Spacer()
            }
            .foregroundStyle(.white)
            
            // MARK: Content
            ScrollView {
                Markdown(model.body)
                    .markdownTextStyle(\.text) {
                        ForegroundColor(.white)
                    }
                    .markdownBlockStyle(\.image) { config in
                        config.label
                            .clipShape(RoundedRectangle(cornerRadius: 8))
                    }
                    .padding(.top, 6)
            }
            .scrollClipDisabled()
            .mask {
                VStack(spacing: 0) {
                    LinearGradient(colors: [.black, .clear], startPoint: .bottom, endPoint: .top)
                        .frame(height: 10)
                    Color.black
                    LinearGradient(colors: [.black, .clear], startPoint: .top, endPoint: .bottom)
                        .frame(height: 10)
                }
            }
        }
        .padding(.horizontal)
        .background {
            LinearGradient(colors: model.colorObjects,
                           startPoint: .topLeading,
                           endPoint: .bottomTrailing)
            .ignoresSafeArea(edges: .all)
        }
        .navigationBarBackButtonHidden()
        .statusBarHidden()
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
            .padding(.horizontal, 10)
            .padding(.vertical, 4)
            .blendMode(.destinationOut)
            .background(Capsule().fill(.regularMaterial))
            .compositingGroup()
        }
        .buttonStyle(.plain)
    }
}

private struct minimizeButton: View {
    
    let action: () -> Void
    
    var body: some View {
        Button {
            action()
        } label: {
            Image(systemName: "arrow.down.right.and.arrow.up.left")
                .font(.body)
                .fontWeight(.semibold)
                .blendMode(.destinationOut)
                .padding(6)
                .background(Capsule().fill(.regularMaterial))
                .compositingGroup()
        }
        .buttonStyle(.plain)
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
    
    NavigationStack {
        AnnouncementDetailsView(message: dummyMessage!) {
            print("dismissed")
        }
    }
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
       "title": "what i do 💜",
       "body": "What would you do if when you okay so he said yes would go? Uhm... I would tell him god bless him.\\n\\n ![dummy](https://i.kym-cdn.com/photos/images/newsfeed/002/436/043/938)\\n\\nI really wish that this would work but it's being quite difficult :(",
       "id": "1"
     }
    """)
    
    NavigationStack {
        AnnouncementDetailsView(message: dummyMessage!) {
            print("dismissed")
        }
    }
}
