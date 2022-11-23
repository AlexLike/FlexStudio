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

    var position: CGSize {
        get { .init(width: positionX_, height: positionY_) }
        set {
            layer_?.objectWillChange.send()
            positionX_ = newValue.width
            positionY_ = newValue.height
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
                       position: CGSize) -> Keyframe
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
