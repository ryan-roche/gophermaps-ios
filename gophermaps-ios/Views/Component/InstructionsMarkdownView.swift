//
//  InstructionsMarkdownView.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/7/24.
//

import MarkdownUI
import SwiftUI

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

    init(dirName: String) {
        let docsDir = FileManager.default.urls(
            for: .documentDirectory, in: .userDomainMask
        ).first!

        self.routeID = dirName
        self.instructionsDirectoryURL = docsDir
            .appendingPathComponent("instructions")
            .appendingPathComponent(dirName)
        self.markdownURL = instructionsDirectoryURL.appendingPathComponent(
            "instructions.md")

        #if DEBUG
            let fm = FileManager.default

            // Copy preview content instructions from bundle

            // Instructions directory
            if !fm.fileExists(atPath: instructionsDirectoryURL.path) {
                try! fm.createDirectory(
                    at: instructionsDirectoryURL,
                    withIntermediateDirectories: true)
            }

            // instructions.md
            if fm.fileExists(atPath: markdownURL.path) {
                try! fm.removeItem(at: markdownURL)
            }
            try! fm.copyItem(
                at: Bundle.main.url(
                    forResource: "instructions", withExtension: "md")!,
                to: markdownURL)

            // img1.jpg
            let imgTargetURL = instructionsDirectoryURL.appendingPathComponent(
                "img1.jpg")
            if !fm.fileExists(atPath: imgTargetURL.path) {
                try! fm.copyItem(
                    at: Bundle.main.url(
                        forResource: "img1", withExtension: "jpg")!,
                    to: imgTargetURL)
            }
        #endif
    }

    /// Uses a regex to extract the alt text from a Markdown Image entry
    /// - Parameter markdown: A markdown string of the format `![alt text](imageURL)`
    /// - Returns: A string containing either the alt text or an error message if it failed to extract
    private func yankAltText(from markdown: String) -> String {
        let pattern = #"!\[([^\]]*)\]\([^\)]+\)"#
        guard
            let regex = try? NSRegularExpression(pattern: pattern, options: [])
        else {
            return "Error Loading Text"
        }
        let nsString = markdown as NSString
        let results = regex.matches(
            in: markdown, options: [],
            range: NSRange(location: 0, length: nsString.length))

        // Extract the first match's alt text
        if let match = results.first,
            let range = Range(match.range(at: 1), in: markdown)
        {
            return String(markdown[range])
        }

        return "Error Loading Text"
    }

    var body: some View {
        if let markdownContent = try? String(
            contentsOf: markdownURL, encoding: .utf8)
        {
            // MARK: Markdown Content
            ScrollView {
                Markdown(
                    markdownContent, imageBaseURL: instructionsDirectoryURL
                )
                .markdownImageProvider(.documents)
                .markdownBlockStyle(\.image) { configuration in
                        VStack(spacing: 0) {
                            configuration.label
                                .accessibilityLabel("Step instructions image")

                            Text(
                                yankAltText(
                                    from: configuration.content.renderMarkdown()
                                )
                            )
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background {
                                configuration.label
                                    .scaleEffect(x:1, y:-1)
                                    .overlay {
                                        FrostedGlassView(
                                            effect: .systemMaterial,
                                            blurRadius: 16
                                        )
                                        .padding(-2)
                                    }
                            }
                            .clipped()
                        }
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                        .shadow(color: .black.opacity(0.2), radius: 8, y: 8)
                    }
                    .padding()
            }
        } else {
            // MARK: Load Error Message
            ContentUnavailableView(
                "Failed to load Instructions", systemImage: "square.3.layers.3d"
            )
            .foregroundStyle(.secondary)
            .onAppear {
                print("Failed to load instructions at \(markdownURL.absoluteString)")
            }
        }
    }
}

#Preview {
    InstructionsMarkdownView(dirName: "testInstructions")
}
