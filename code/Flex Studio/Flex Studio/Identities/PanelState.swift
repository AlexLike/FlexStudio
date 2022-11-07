//
//  PanelState.swift
//  Flex Studio
//
//  Created by Kai Zheng on 07.11.22.
//

import Foundation

enum PanelState: Equatable {
    case `static`
    case onResize(onDrag: Bool)
}
