//
//  DocumentsImageProvider.swift
//  gophermaps-ios
//
//  Created by Ryan Roche on 11/5/24.
//

import SwiftUI
import MarkdownUI

struct ResizeToFit: Layout {
  func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
    guard let view = subviews.first else {
      return .zero
    }

    var size = view.sizeThatFits(.unspecified)

    if let width = proposal.width, size.width > width {
      let aspectRatio = size.width / size.height
      size.width = width
      size.height = width / aspectRatio
    }
    return size
  }

  func placeSubviews(
    in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()
  ) {
    guard let view = subviews.first else { return }
    view.place(at: bounds.origin, proposal: .init(bounds.size))
  }
}


/// An image provider that loads images from the app's documents directory
public struct DocumentsImageProvider: ImageProvider {
    public init() {}
    
    public func makeImage(url: URL?) -> some View {
        if let url = url,
           let data = try? Data(contentsOf: url),
           let image = UIImage(data: data) {
            ResizeToFit {
                Image(uiImage: image)
                    .resizable()
            }
        }
    }
}



// Extension to make the provider easily accessible
public extension ImageProvider where Self == DocumentsImageProvider {
    /// An image provider that loads images from the app's documents directory
    static var documents: DocumentsImageProvider {
        DocumentsImageProvider()
    }
}
