//
//  Layer.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import CoreData
import PencilKit

extension Layer {
    // MARK: - Data

    /// A value in `0..<(panel.layers.count)`, denoting how close this layer is to the viewer. (`0`
    /// is furthest to the back.)
    var order: Int16 {
        get { order_ }
        set { order_ = newValue }
    }

    /// The drawing pictured by this layer.
    var drawing: PKDrawing {
        get { (drawing_ as? PKDrawingReference) as? PKDrawing ?? .init() }
        set { drawing_ = newValue as PKDrawingReference }
    }

    var isVisible: Bool {
        get { isVisible_ }
        set { isVisible_ = newValue }
    }

    var pinLocation: PinLocation? {
        get { pinLocation_ >= 0 ? .from(id: pinLocation_) : nil }
        set {
            if let newValue {
                pinLocation_ = newValue.id
            } else {
                pinLocation_ = -1
            }
        }
    }

    // MARK: - Relationships

    /// The panel containing this layer.
    var panel: Panel {
        get { panel_! }
        set { panel_ = newValue }
    }

    var keyframes: Set<Keyframe> {
        get { keyframes_ as? Set<Keyframe> ?? [] }
        set { keyframes_ = newValue as NSSet }
    }
    
    var sortedKeyframes: [Keyframe] { keyframes.sorted(using: KeyPathComparator(\Keyframe.aspectProgression))
    }

    // MARK: - CD operations

    @discardableResult
    static func create(for panel: Panel, order: Int16) -> Layer {
        let l = Layer(context: panel.managedObjectContext!)
        l.order = order
        l.drawing = PKDrawing()
        l.panel = panel
        l.isVisible = true
        panel.layers.insert(l)
        return l
    }

    func delete(removingFromPanel: Bool = true) {
        let context = managedObjectContext!
        
        if removingFromPanel {
            panel.removeFromLayers_(self)
        }

        keyframes.forEach { $0.delete(removingFromLayer: false) }
        keyframes = []

        Task(priority: .utility) {
            try await Task.sleep(for: .seconds(1))
            assert((try? validateForDelete()) != nil)
            context.delete(self)
        }
    }
}
