//
//  PKDrawing+Thumbnail.swift
//  Flex Studio
//
//  Created by Alexander Zank on 22.11.22.
//

import PencilKit

extension PKDrawing {
    var thumbnailImage: UIImage {
        let l = max(bounds.width, bounds.height)
        return image(from: bounds, scale: 500 / l)
    }
}
