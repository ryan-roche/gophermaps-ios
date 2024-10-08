//
//  InstructionsMarkdownView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/7/24.
//

import SwiftUI
import MarkdownUI


enum markdownLoadStatus {
    case idle
    case loading
    case done
    case failed
}

struct InstructionsMarkdownView: View {
    
    @State private var loadStatus: markdownLoadStatus = .idle
    
    let routeID: String
    let instructionsDirectoryURL: URL
    let markdownURL: URL
    
    init(routeID dirName: String) {
        let docsDir = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        self.routeID = dirName
        self.instructionsDirectoryURL = docsDir.appendingPathComponent(dirName)
        self.markdownURL = instructionsDirectoryURL.appendingPathComponent("instructions.md")
        
        #if DEBUG
        let fm = FileManager.default
        
        // Copy preview content instructions from bundle
        
        // Instructions directory
        if !fm.fileExists(atPath: instructionsDirectoryURL.path) {
            try! fm.createDirectory(at: instructionsDirectoryURL, withIntermediateDirectories: true)
        }
        
        // instructions.md
        if fm.fileExists(atPath: markdownURL.path) {
            try! fm.removeItem(at: markdownURL)
        }
        try! fm.copyItem(at: Bundle.main.url(forResource: "instructions", withExtension:"md")!, to: markdownURL)
        
        // img1.jpg
        let imgTargetURL = instructionsDirectoryURL.appendingPathComponent("img1.jpg")
        if !fm.fileExists(atPath: imgTargetURL.path) {
            try! fm.copyItem(at: Bundle.main.url(forResource:"img1", withExtension:"jpg")!, to: imgTargetURL)
        }
        #endif
    }
    
    var body: some View {
        if let markdownContent = try? String(contentsOf: markdownURL, encoding:.utf8) {
            ScrollView {
                Markdown(markdownContent, imageBaseURL: instructionsDirectoryURL).markdownImageProvider(.asset)
            }
        } else {
            ContentUnavailableView("Failed to load Instructions", systemImage: "square.3.layers.3d")
            .foregroundStyle(.secondary)
        }
    }
}

#Preview {
    InstructionsMarkdownView(routeID: "testInstructions")
}
