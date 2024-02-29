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
            markdownContent = try MarkdownContent(String(contentsOf: markdownURL))
        } catch {
            markdownContent = MarkdownContent("Failed to open file.")
        }
    }
    
    var body: some View {
        ScrollView {
            Markdown(markdownContent)
                .markdownImageProvider(.default)
                .padding()
        }
    }
}

#Preview {
    // Loads the markdown file from the bundle (Preview Content) and
    // loads the images from the network (GitHub)
    InstructionFileView(markdownURL: Bundle.main.url(forResource: "test-instructions", withExtension: "md")!)
}
