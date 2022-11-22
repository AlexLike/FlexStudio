//
//  KeyframeOverlay.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import SwiftUI

struct KeyframeOverlay<A: KeyframeAssistant>: ResponsivityOverlay {
    let assistant: A

    @State private var initialOffset: CGSize?
    var gesture: some Gesture {
        return DragGesture()
        .onChanged { g in
            if initialOffset == nil {
                initialOffset = assistant.currentOffset
            }

            if let initialOffset {
                assistant.modifyCurrentKeyframePosition(to: .init(
                    width: initialOffset.width + g.translation.width,
                    height: initialOffset.height + g.translation.height
                ))
            }
        }
        .onEnded { _ in
            initialOffset = nil
        }
    }
    
    var body: some View {
        GeometryReader{ _ in}
            .contentShape(Rectangle())
            .gesture(gesture)
    }
}
