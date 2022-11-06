//
//  DrawingTransformer.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import CoreData
import PencilKit

class DrawingTransformer: ValueTransformer {
    static let logger = Logger.forType(DrawingTransformer.self)
    static let name = NSValueTransformerName("DrawingTransformer")

    static func register() {
        let shared = DrawingTransformer()
        ValueTransformer.setValueTransformer(shared, forName: Self.name)
    }

    override class func transformedValueClass() -> AnyClass {
        PKDrawingReference.self
    }

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let drawing = value as? PKDrawingReference else {
            Self.logger.error("Not passed a PKDrawingReference. This is illegal.")
            assertionFailure()
            return nil
        }

        Self.logger.notice("Transformed a PKDrawingReference to Data.")
        return drawing.dataRepresentation()
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            Self.logger.error("Not passed Data. This is illegal.")
            assertionFailure()
            return nil
        }

        do { return try PKDrawingReference(data: data) }
        catch {
            Self.logger.error("Passed invalid Data. This is illegal.")
            assertionFailure()
            return nil
        }
    }
}
