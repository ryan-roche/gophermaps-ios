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
    @Binding var filename: String
    
    init(filename: Binding<String>) {
        self._filename = filename
        do {
            if let markdownURL = Bundle.main.url(forResource: filename.wrappedValue, withExtension: "md") {
                // attempts to read file content into a string
                markdownContent = try MarkdownContent(String(contentsOf: markdownURL))
            } else {
                markdownContent = MarkdownContent("Failed to generate file URL.")
            }
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
        @State var filename = "test-instructions"
        var body: some View {
            ScrollView {
                InstructionFileView(filename: $filename)
            }
        }
    }
    return PreviewWrapper()
}
