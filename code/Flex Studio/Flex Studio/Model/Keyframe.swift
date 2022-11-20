//
//  Keyframe.swift
//  Flex Studio
//
//  Created by Alexander Zank on 20.11.22.
//

import CoreData

extension Keyframe {
    // MARK: - Data

    var aspectProgression: CGFloat { aspectProgression_ }

    var position: CGPoint {
        get { .init(x: positionX_, y: positionY_) }
        set {
            positionX_ = newValue.x
            positionY_ = newValue.y
        }
    }

    // MARK: - Relationships

    var layer: Layer {
        get { layer_! }
        set { layer_ = newValue }
    }

    // MARK: - CD operations

    @discardableResult
    static func create(for layer: Layer, at aspectProgression: CGFloat,
                       position: CGPoint) -> Keyframe
    {
        let k = Keyframe(context: layer.managedObjectContext!)
        k.aspectProgression_ = aspectProgression
        k.position = position
        k.layer = layer

        layer.keyframes.insert(k)

        return k
    }

    func delete(removingFromLayer: Bool = true) {
        let context = managedObjectContext!

        if removingFromLayer {
            layer.removeFromKeyframes_(self)
        }

        Task(priority: .utility) {
            try await Task.sleep(for: .seconds(1))
            assert((try? validateForDelete()) != nil)
            context.delete(self)
        }
    }
}
