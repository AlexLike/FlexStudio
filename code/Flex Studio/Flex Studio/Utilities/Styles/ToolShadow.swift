//
//  ToolShadow.swift
//  Flex Studio
//
//  Created by Alexander Zank on 22.11.22.
//

import SwiftUI

extension View {
    func toolShadow(strength: CGFloat = 1) -> some View {
        self.shadow(color: .black.opacity(0.2 + 0.1 * (strength - 1)), radius: 48 / strength)
    }
}
