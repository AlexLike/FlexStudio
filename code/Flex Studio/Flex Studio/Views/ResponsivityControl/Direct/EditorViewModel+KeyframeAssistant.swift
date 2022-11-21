//
//  EditorViewModel+KeyframeAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 20.11.22.
//

import Foundation

extension EditorViewModel: KeyframeAssistant {
    var sortedKeyframeProgressions: [CGFloat] {
        selectedLayer.sortedKeyframes.map(\.aspectProgression)
    }

    func toggleKeyframe() {
        if let k = selectedLayer.keyframes
            .first(where: { $0.aspectProgression == aspectProgression }) {
            k.delete(removingFromLayer: true)
        } else {
            Keyframe.create(for: selectedLayer, at: aspectProgression, position: .zero)
        }
    }
    
    func computeDirectTranslation(for layer: Layer) -> CGSize {
        .zero
    }
}
