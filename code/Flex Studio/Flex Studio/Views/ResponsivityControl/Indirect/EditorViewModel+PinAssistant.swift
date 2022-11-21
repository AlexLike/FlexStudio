//
//  EditorViewModel+PinAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 20.11.22.
//

import Foundation

extension EditorViewModel: PinAssistant {
    var selectedPinLocation: PinLocation? {
        get { selectedLayer.pinLocation }
        set { selectedLayer.pinLocation = newValue }
    }

    private static let squareRect = Dimensions.rect(
        for: Dimensions.minFrameSize,
        in: Dimensions.canvasSize
    )

    func computeIndirectTranslation(for layer: Layer) -> CGSize {
        guard case let .some(.loc(v, h)) = layer.pinLocation else { return .zero }
        
        let dh2 = aspectProgression >= 0.5 ?
            (aspectProgression - 0.5) * Dimensions.minFrameLength :
            0
        
        let px = (layer.drawing.bounds.midX - Dimensions.canvasLength / 2) / Dimensions.minFrameLength + 0.5

        let dw2 = aspectProgression <= 0.5 ?
            (0.5 - aspectProgression) * Dimensions.minFrameLength :
            0
        
        let py = (layer.drawing.bounds.midY - Dimensions.canvasLength / 2) / Dimensions.minFrameLength + 0.5

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
            ty = dh2 * ( 2 * py - 1 )
        case .bottom:
            ty = dh2
        }

        return .init(width: tx, height: ty)
    }
}
