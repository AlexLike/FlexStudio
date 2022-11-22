//
//  ResponsivityOverlayView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import SwiftUI

protocol ResponsivityOverlay: View {}

struct ResponsivityOverlayView<O: ResponsivityOverlay, A>: View {
    let overlay: O
    let isActive: Bool

    var body: some View {
        overlay
            .allowsHitTesting(isActive)
    }
}

extension ResponsivityOverlayView where O == PinOverlay<A> {
    static func indirect(
        isActive: Bool,
        assistant: A
    ) -> Self {
        .init(
            overlay: PinOverlay(assistant: assistant),
            isActive: isActive
        )
    }
}

extension ResponsivityOverlayView where O == KeyframeOverlay<A> {
    static func direct(
        isActive: Bool,
        assistant: A
    ) -> Self {
        .init(
            overlay: KeyframeOverlay(assistant: assistant),
            isActive: isActive
        )
    }
}
