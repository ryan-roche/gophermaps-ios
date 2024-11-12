//
//  InstructionsBrowser.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 10/2/24.
//

import SwiftUI

struct DocumentsDebugView: View {
    @State private var expandedPaths: Set<String> = []
    let fileManager = FileManager.default
    
    var body: some View {
        NavigationView {
            List {
                let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0]
                FileItemView(url: documentsURL, expandedPaths: $expandedPaths)
            }
            .listStyle(.inset)
            .navigationTitle("Documents Directory")
        }
    }
}

struct FileItemView: View {
    let url: URL
    @Binding var expandedPaths: Set<String>
    @State private var isLoading = false
    @State private var error: Error?
    @State private var contents: [URL] = []
    
    private var isDirectory: Bool {
        var isDir: ObjCBool = false
        FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)
        return isDir.boolValue
    }
    
    private var isExpanded: Bool {
        expandedPaths.contains(url.path)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if isDirectory {
                    Image(systemName: isExpanded ? "chevron.down" : "chevron.right")
                        .foregroundColor(.blue)
                    Image(systemName: "folder.fill")
                        .foregroundColor(.blue)
                } else {
                    Image(systemName: "doc.fill")
                        .foregroundColor(.gray)
                        .padding(.leading, 20)
                }
                
                Text(url.lastPathComponent)
                    .lineLimit(1)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                if isDirectory {
                    toggleExpansion()
                }
            }
            
            if isDirectory && isExpanded {
                if isLoading {
                    ProgressView()
                        .padding(.leading, 40)
                } else if let error = error {
                    Text("Error: \(error.localizedDescription)")
                        .foregroundColor(.red)
                        .padding(.leading, 40)
                } else {
                    LazyVStack(alignment: .leading) {
                        ForEach(contents, id: \.path) { itemURL in
                            FileItemView(url: itemURL, expandedPaths: $expandedPaths)
                                .padding(.leading, 20)
                        }
                    }
                }
            }
        }
    }
    
    private func toggleExpansion() {
        if isExpanded {
            expandedPaths.remove(url.path)
        } else {
            expandedPaths.insert(url.path)
            loadContents()
        }
    }
    
    private func loadContents() {
        guard isDirectory else { return }
        
        isLoading = true
        error = nil
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                let contents = try FileManager.default.contentsOfDirectory(
                    at: url,
                    includingPropertiesForKeys: [.isDirectoryKey],
                    options: [.skipsHiddenFiles]
                ).sorted { $0.lastPathComponent < $1.lastPathComponent }
                
                DispatchQueue.main.async {
                    self.contents = contents
                    self.isLoading = false
                }
            } catch {
                DispatchQueue.main.async {
                    self.error = error
                    self.isLoading = false
                }
            }
        }
    }
}

// Preview provider for SwiftUI canvas
struct DirectoryContentsDebugView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentsDebugView()
    }
}
