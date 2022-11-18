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

extension ButtonStyle where Self == StaticButtonStyle  {
    static var `static`: Self { .init() }
}
