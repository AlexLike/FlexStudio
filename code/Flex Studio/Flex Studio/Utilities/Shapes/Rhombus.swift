//
//  Rhombus.swift
//  Flex Studio
//
//  Created by Alexander Zank on 18.11.22.
//

import SwiftUI

struct Rhombus: Shape {
    func path(in rect: CGRect) -> Path {
        Path { p in
            p.move(to: .init(x: rect.midX, y: rect.minY))
            p.addLine(to: .init(x: rect.maxX, y: rect.midY))
            p.addLine(to: .init(x: rect.midX, y: rect.maxY))
            p.addLine(to: .init(x: rect.minX, y: rect.midY))
            p.closeSubpath()
        }
    }
}
