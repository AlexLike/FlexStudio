//
//  EditorTool.swift
//  Flex Studio
//
//  Created by Alexander Zank on 02.11.22.
//

import Foundation
import PencilKit

enum EditorTool {
    /// Draw on the selected layer using `tool`.
    case draw(tool: PKTool)
    /// Edit the responsivity parameters of the selected layer.
    case responsivity
    
    static var debugDraw: Self { .draw(tool: PKInkingTool(.pen, color: .black)) }
    static var debugErase: Self { .draw(tool: PKEraserTool(.bitmap)) }
}
