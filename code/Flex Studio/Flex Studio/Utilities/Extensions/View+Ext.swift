//
//  View+Ext.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

private struct ButtonStyleScale: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 1.02 : 1)
    }
}

extension View {
    func fsButtonStyleScale() -> some View {
        self
            .buttonStyle(withAnimation(.easeInOut(duration: 0.15)) { ButtonStyleScale() })
    }
}
