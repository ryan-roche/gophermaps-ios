//
//  InstructionFileView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 2/28/24.
//

import SwiftUI
import MarkdownUI

struct InstructionFileView: View {
    let markdownURL: URL
    let markdownContent : MarkdownContent
    
    init(markdownURL: URL) {
        self.markdownURL = markdownURL
        
        do {
            // attempts to read file content into a string
            markdownContent = try MarkdownContent(String(contentsOf: markdownURL))
        } catch {
            // this should only happen if something catastrophic happened with downloading the file
            markdownContent = MarkdownContent("Failed to open file.")
        }
    }
    
    var body: some View {
        ScrollView {
            // TODO: See if there's a way to display a throbber of some sort whilst loading an image
            Markdown(markdownContent)
                .markdownImageProvider(.default)
                .markdownBlockStyle(\.image) { config in
                    config.label
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                        .shadow(radius: 2, y:2)
                }
                .padding()
        }
    }
}

#Preview {
    // Loads the markdown file from the bundle (Preview Content) and
    // loads the images from the network (GitHub)
    // TODO: Figure out loading files from storage
    InstructionFileView(markdownURL: Bundle.main.url(forResource: "test-instructions", withExtension: "md")!)
}
