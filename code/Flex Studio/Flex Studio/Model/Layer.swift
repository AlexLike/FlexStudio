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
        get { (drawing_ as! PKDrawingReference) as PKDrawing }
        set { drawing_ = newValue as PKDrawingReference }
    }

    // MARK: - Relationships

    /// The panel containing this layer.
    var panel: Panel {
        get { panel_! }
        set { panel_ = newValue }
    }

    // MARK: - CD operations

    @discardableResult
    static func create(for panel: Panel, order: Int16) -> Layer {
        let l = Layer(context: panel.managedObjectContext!)
        l.order = order
        l.drawing = PKDrawing()
        l.panel = panel
        panel.layers.insert(l)
        return l
    }

    func delete(removingFromPanel: Bool = true) {
        let context = managedObjectContext!
        if removingFromPanel {
            panel.layers.remove(self)
        }
        context.delete(self)
    }
}
