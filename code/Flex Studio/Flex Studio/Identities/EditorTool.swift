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
    case draw(tool: PKTool, isRulerActive: Bool)
    /// Edit the responsivity parameters of the selected layer.
    case responsivity(byDragging: Bool)

    static var defaultDraw: Self { .draw(tool: PKInkingTool(.pen, color: .black), isRulerActive: false) }
    static var defaultErase: Self { .draw(tool: PKEraserTool(.bitmap), isRulerActive: false) }
    
    static func fromDrawToolPicker(state: DrawToolPickerState) -> Self? {
        switch state {
        case .pick(let tool, let isRulerActive):
            return .draw(tool: tool, isRulerActive: isRulerActive)
        case .hidden:
            return nil
        }
    }
}
