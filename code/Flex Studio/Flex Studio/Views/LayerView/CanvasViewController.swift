//
//  CanvasViewController.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI
import PencilKit

class CanvasViewController: UIViewController {
    var layer: Layer
    var state: LayerState
    var drawingChanged: (PKDrawing) -> () = { _ in }
    
    var canvasView: PKCanvasView = PKCanvasView()
    var toolPicker: PKToolPicker = PKToolPicker()

    init(layer: Layer, state: LayerState) {
        self.layer = layer
        self.state = state
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureCanvas()
        configureToolPicker()
        
        view.addSubview(canvasView)
        canvasView.frame = view.bounds
        
        reconfigure()
    }
    
    private func configureCanvas() {
        canvasView.delegate = self
        canvasView.drawing = layer.drawing
        canvasView.becomeFirstResponder()
        
        canvasView.drawingPolicy = .anyInput
        canvasView.isOpaque = false
        canvasView.overrideUserInterfaceStyle = .light
        
        canvasView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    private func configureToolPicker() {
        toolPicker.addObserver(self)
        toolPicker.setVisible(true, forFirstResponder: canvasView)
        toolPicker.addObserver(canvasView)
    }
    
    func reconfigure() {
        switch state {
        case .static, .editable(tool: .responsivity):
            canvasView.isUserInteractionEnabled = false
        case .editable(tool: .draw(_)):
            canvasView.isUserInteractionEnabled = true
        }
    }
}

extension CanvasViewController: PKToolPickerObserver, PKCanvasViewDelegate {
    func canvasViewDrawingDidChange(_ canvasView: PKCanvasView) {
        drawingChanged(canvasView.drawing)
    }
}
