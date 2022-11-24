//
//  Panel+Thumbnail.swift
//  Flex Studio
//
//  Created by Alexander Zank on 23.11.22.
//

import UIKit

extension Panel {
    func updateThumbnail(variant: ResponsivityInterfaceVariant) {
        UIGraphicsBeginImageContextWithOptions(Geometry.minFrameSize, false, 2)
        for layer in sortedLayers {
            let translation: CGSize
            switch variant {
            case .indirect:
                translation = Geometry.computeIndirectTranslation(for: layer, at: 0.5)
            case .direct:
                translation = Geometry.computeDirectTranslation(for: layer, at: 0.5)
            }
            let trueOriginDistance = (Geometry.canvasLength - Geometry.minFrameLength) / 2
            layer.drawing.image(
                from: .init(
                    origin: .init(
                        x: trueOriginDistance - translation.width,
                        y: trueOriginDistance - translation.height
                    ),
                    size: Geometry.minFrameSize
                ),
                scale: 2
            ).draw(at: .zero)
        }
        thumbnail = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
    }
}
