//
//  LayerView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import PencilKit
import SwiftUI

struct LayerView: UIViewRepresentable {
    @ObservedObject var layer: Layer
    let state: LayerState

    func makeCoordinator() -> CanvasManager {
        CanvasManager(layer: layer)
    }

    func makeUIView(context: Context) -> PKCanvasView {
        let canvas = PKCanvasView()
        canvas.drawingPolicy = .anyInput
        canvas.isOpaque = false
        canvas.overrideUserInterfaceStyle = .light
        canvas.drawing = layer.drawing
        canvas.delegate = context.coordinator
        reconfigure(canvas)
        return canvas
    }

    func updateUIView(_ canvas: PKCanvasView, context _: Context) {
        if layer.drawing != canvas.drawing {
            // A concurrent version of this layer was updated.
            canvas.drawing = layer.drawing
        }
        reconfigure(canvas)
    }

    private func reconfigure(_ canvas: PKCanvasView) {
        switch state {
        case .static, .editable(tool: .responsivity):
            canvas.isUserInteractionEnabled = false
        case let .editable(tool: .draw(tool, isRulerActive)):
            canvas.isUserInteractionEnabled = true
            canvas.tool = tool
            canvas.isRulerActive = isRulerActive
        }
    }

    class CanvasManager: NSObject, PKCanvasViewDelegate {
        let layer: Layer

        init(layer: Layer) {
            self.layer = layer
        }

        func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
            layer.drawing = canvas.drawing
        }
    }
}

struct LayerView_Previews: PreviewProvider {
    static var previews: some View {
        LayerView(
            layer: try! PersistenceLayer.preview.viewContext.fetch(Layer.fetchRequest()).first!,
            state: .editable(tool: .defaultDraw)
        )
    }
}
