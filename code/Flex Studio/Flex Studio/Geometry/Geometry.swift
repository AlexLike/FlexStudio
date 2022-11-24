//
//  Geometry.swift
//  Flex Studio
//
//  Created by Alexander Zank on 20.11.22.
//

import Foundation

enum Geometry {
    /// The minimum width and height of the panel.
    static let minFrameLength: CGFloat = 400
    static let minFrameSize: CGSize = .init(width: minFrameLength, height: minFrameLength)

    /// The maximum scale of width or height of the panel.
    static let maxFrameScale: CGFloat = 2

    /// The minimal size required for a backing canvas to cover all aspect progression settings.
    static let canvasLength: CGFloat = 2 * Self.minFrameLength * Self.maxFrameScale
    static let canvasSize: CGSize = .init(width: canvasLength, height: canvasLength)
    
    static let layerThumbnailLength: CGFloat = 200
    static let panelThumbnailLength: CGFloat = 600

    /// The size of the panel for a given aspect progression.
    static func panelSize(for aspectProgression: CGFloat) -> CGSize {
        aspectProgression <= 0.5 ?
            .init(
                width: Self.minFrameLength + (Self.maxFrameScale - 1) * Self.minFrameLength
                    * (1 - 2 * aspectProgression),
                height: Self.minFrameLength
            ) :
            .init(
                width: Self.minFrameLength,
                height: Self.minFrameLength + (Self.maxFrameScale - 1) * Self.minFrameLength
                    * (aspectProgression - 0.5) * 2
            )
    }

    /// The rectangle describing a frame of given size in the coordinate system of its parent of
    /// given size.
    static func rect(for frameSize: CGSize, in viewSize: CGSize) -> CGRect {
        .init(origin: .init(x: (viewSize.width - frameSize.width) / 2,
                            y: (viewSize.height - frameSize.height) / 2), size: frameSize)
    }
}
