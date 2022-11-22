//
//  Geometry+KeyframeLogic.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import Foundation

extension Geometry {
    static func computeDirectTranslation(
        for layer: Layer,
        at aspectProgression: CGFloat
    ) -> CGSize {
        let skfs = layer.sortedKeyframes

        let l = skfs
            .last(where: { $0.aspectProgression <= aspectProgression })
        let r = skfs
            .first(where: { $0.aspectProgression >= aspectProgression })

        if let l, let r, l != r {
            let t = (aspectProgression - l.aspectProgression) /
                (r.aspectProgression - l.aspectProgression)

            return .init(
                width: l.position.width + t * (r.position.width - l.position.width),
                height: l.position.height + t * (r.position.height - l.position.height)
            )

        } else if let l {
            return l.position

        } else if let r {
            return r.position

        }
        
        return .zero
    }
}
