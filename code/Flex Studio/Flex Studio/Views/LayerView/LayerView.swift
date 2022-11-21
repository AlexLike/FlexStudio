//
//  LayerView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import PencilKit
import SwiftUI

struct LayerView: UIViewRepresentable {
    @ObservedObject var viewModel: PanelViewModel
    @ObservedObject var layer: Layer
    let state: LayerState

    func makeCoordinator() -> CanvasManager {
        CanvasManager(viewModel: viewModel, layer: layer)
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
        let viewModel: PanelViewModel
        let layer: Layer

        init(viewModel: PanelViewModel, layer: Layer) {
            self.viewModel = viewModel
            self.layer = layer
        }

        func canvasViewDrawingDidChange(_ canvas: PKCanvasView) {
            layer.drawing = canvas.drawing
            viewModel.savePreviewImage(for: layer, panel: layer.panel)
        }
    }
}

