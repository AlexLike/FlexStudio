//
//  PKDrawing+Thumbnail.swift
//  Flex Studio
//
//  Created by Alexander Zank on 22.11.22.
//

import PencilKit

extension PKDrawing {
    var thumbnailImage: UIImage {
        return image(from: bounds, scale: 1)
    }
}
