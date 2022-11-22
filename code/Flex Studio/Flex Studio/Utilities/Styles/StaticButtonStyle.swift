//
//  StaticButtonStyle.swift
//  Flex Studio
//
//  Created by Alexander Zank on 17.11.22.
//

import SwiftUI

struct StaticButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

extension ButtonStyle where Self == StaticButtonStyle {
    /// Render only the label, exactly as described and without gesture-induced changes.
    static var `static`: Self { .init() }
}
