//
//  ImageTransformer.swift
//  Flex Studio
//
//  Created by Alexander Zank on 23.11.22.
//

import Foundation

import CoreData
import UIKit

class ImageTransformer: ValueTransformer {
    static let logger = Logger.forType(ImageTransformer.self)
    static let name = NSValueTransformerName("ImageTransformer")

    static func register() {
        let shared = ImageTransformer()
        ValueTransformer.setValueTransformer(shared, forName: Self.name)
    }

    override class func transformedValueClass() -> AnyClass {
        UIImage.self
    }

    override class func allowsReverseTransformation() -> Bool {
        true
    }

    override func transformedValue(_ value: Any?) -> Any? {
        guard let image = value as? UIImage else {
            Self.logger.error("Not passed a UIImage. This is illegal.")
            assertionFailure()
            return nil
        }
        
        guard let imageData = image.pngData() else {
            Self.logger.error("Couldn't synthesize PNG data from an image. Ignoring.")
            return nil
        }

        Self.logger.notice("Transformed a UIImage to Data.")
        return imageData
    }

    override func reverseTransformedValue(_ value: Any?) -> Any? {
        guard let data = value as? Data else {
            Self.logger.error("Not passed Data. This is illegal.")
            assertionFailure()
            return nil
        }
        
        guard let image = UIImage(data: data) else {
            Self.logger.error("Passed invalid Data. This is illegal.")
            assertionFailure()
            return nil
        }
        
        return image
    }
}
