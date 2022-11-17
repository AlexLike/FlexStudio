//
//  DrawToolPickerState.swift
//  Flex Studio
//
//  Created by Alexander Zank on 15.11.22.
//

import PencilKit

enum DrawToolPickerState {
    /// The draw tool picker isn't visible.
    case hidden
    /// The draw tool picker is visible with `tool` being selected.
    case pick(tool: PKTool, isRulerActive: Bool)

    static func forEditor(tool editorTool: EditorTool?) -> Self {
        switch editorTool {
        case .some(.draw(let tool, let isRulerActive)):
            return .pick(tool: tool, isRulerActive: isRulerActive)
        case .some(.responsivity), .none:
            return .hidden
        }
    }
}
