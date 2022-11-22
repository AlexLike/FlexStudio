//
//  Geometry+PinLogic.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import Foundation

extension Geometry {
    static func computeIndirectTranslation(
        for layer: Layer,
        at aspectProgression: CGFloat
    ) -> CGSize {
        guard case let .some(.loc(v, h)) = layer.pinLocation else { return .zero }

        let dh2 = aspectProgression >= 0.5 ?
            (aspectProgression - 0.5) * Geometry.minFrameLength :
            0

        let px = (layer.drawing.bounds.midX - Geometry.canvasLength / 2) / Geometry
            .minFrameLength + 0.5

        let dw2 = aspectProgression <= 0.5 ?
            (0.5 - aspectProgression) * Geometry.minFrameLength :
            0

        let py = (layer.drawing.bounds.midY - Geometry.canvasLength / 2) / Geometry
            .minFrameLength + 0.5

        let tx: CGFloat
        switch h {
        case .left:
            tx = -dw2
        case .center:
            tx = dw2 * (2 * px - 1)
        case .right:
            tx = dw2
        }

        let ty: CGFloat
        switch v {
        case .top:
            ty = -dh2
        case .center:
            ty = dh2 * (2 * py - 1)
        case .bottom:
            ty = dh2
        }

        return .init(width: tx, height: ty)
    }
}
