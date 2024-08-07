//
//  InstructionFileView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI
import MarkdownUI

struct InstructionFileView: View {
    private let markdownContent : MarkdownContent
    @Binding var edgeName: String
    
    init(edgeName: Binding<String>) {
        self._edgeName = edgeName
        do {
            let docsURL = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            let fileURL = docsURL.appendingPathComponent("\(edgeName.wrappedValue)/instructions.md")
            markdownContent = try MarkdownContent(String(contentsOf: fileURL))
            
        } catch {
            // this should only happen if something catastrophic happened with downloading the file
            markdownContent = MarkdownContent("Failed to load file.")
        }
    }
    
    var body: some View {
        Markdown(markdownContent)
            .markdownImageProvider(.asset)
            .markdownBlockStyle(\.image) { config in
                config.label
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .shadow(radius: 2, y:2)
            }
            .padding()
    }
}

#Preview {
    struct PreviewWrapper: View {
        @State var edgeName = "tb1a-tb2a"
        var body: some View {
            ScrollView {
                InstructionFileView(edgeName: $edgeName)
            }
        }
    }
    return PreviewWrapper()
}
