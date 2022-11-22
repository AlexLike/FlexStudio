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

    var currentKeyframe: Keyframe? {
        selectedLayer.keyframes.first { $0.aspectProgression == aspectProgression }
    }

    var currentOffset: CGSize {
        Geometry.computeDirectTranslation(for: selectedLayer, at: aspectProgression)
    }

    func modifyCurrentKeyframePosition(to target: CGSize) {
        if currentKeyframe == nil {
            toggleKeyframe()
        }
        let currentKeyframe = currentKeyframe!

        currentKeyframe.position = target
        selectedLayer.objectWillChange.send()
    }

    func toggleKeyframe() {
        if let k = selectedLayer.keyframes
            .first(where: { $0.aspectProgression == aspectProgression })
        {
            k.delete(removingFromLayer: true)
        } else {
            Keyframe.create(
                for: selectedLayer,
                at: aspectProgression,
                position: Geometry.computeDirectTranslation(
                    for: selectedLayer,
                    at: aspectProgression
                )
            )
        }
    }
}
