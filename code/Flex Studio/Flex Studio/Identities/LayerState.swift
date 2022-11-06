//
//  LayerState.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import Foundation
import PencilKit

enum LayerState {
    /// This layer preserves its content and responsivity parameters.
    case `static`
    /// This layer is being edited using `tool`.
    case editable(tool: EditorTool)

    static func selected(tool: EditorTool?) -> Self {
        if let tool { return .editable(tool: tool) }
        else { return .static }
    }
}
