//
//  ScaleReactiveButtonStyle.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct ScaleReactiveButtonStyle: ButtonStyle {
    let factor: CGFloat
    let growAnimation: Animation?
    let shrinkAnimation: Animation?

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? factor : 1)
            .animation(
                configuration.isPressed ? growAnimation : shrinkAnimation,
                value: configuration.isPressed
            )
    }
}

extension ButtonStyle where Self == ScaleReactiveButtonStyle {
    /// While the button is being touched, scale its label by a given factor.
    static func scaleReactive(
        factor: CGFloat = 1.02,
        growAnimation: Animation? = nil,
        shrinkAnimation: Animation? = .interactiveSpring(response: 0.5)
    ) -> Self { .init(
        factor: factor,
        growAnimation: growAnimation,
        shrinkAnimation: shrinkAnimation
    ) }
}
