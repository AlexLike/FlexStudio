//
//  LayerView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import PencilKit
import SwiftUI

struct LayerView: UIViewRepresentable {
    @Binding var layer: Layer
    let state: LayerState
    let targetSize: CGSize

    func makeUIView(context _: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.isOpaque = false
        canvas.overrideUserInterfaceStyle = .light
        Self.configure(canvas: canvas, for: state)

        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context _: Context) {
        Self.configure(canvas: canvas, for: state)
        // React to changes in layer and targetSize.
    }

    private static func configure(canvas: PKCanvasView, for state: LayerState) {
        switch state {
        case .static, .editable(tool: .responsivity):
            canvas.isUserInteractionEnabled = false
        case let .editable(tool: .draw(tool)):
            canvas.isUserInteractionEnabled = true
            canvas.tool = tool
        }
    }
}

struct LayerView_Previews: PreviewProvider {
    static var previews: some View {
        LayerView(
            layer: .constant(.init()),
            state: .editable(tool: .draw(tool: PKInkingTool(
                .pen,
                color: .black
            ))),
            targetSize: .zero
        )
    }
}
