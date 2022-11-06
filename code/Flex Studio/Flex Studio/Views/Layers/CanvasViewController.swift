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
    var geometry: GeometryProxy
    
    var canvasView: PKCanvasView = PKCanvasView(frame: .zero)
    var toolPicker: PKToolPicker = PKToolPicker()

    init(layer: Layer, state: LayerState, geometry: GeometryProxy) {
        self.layer = layer
        self.state = state
        self.geometry = geometry
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
        NSLayoutConstraint.activate([
            canvasView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            canvasView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            canvasView.widthAnchor.constraint(equalToConstant: geometry.size.width * 0.7),
            canvasView.heightAnchor.constraint(equalToConstant: geometry.size.height * 0.7)
        ])
        
        reconfigure()
    }
    
    private func configureCanvas() {
        canvasView.delegate = self
        canvasView.drawing = layer.drawing
        canvasView.becomeFirstResponder()
        
        canvasView.drawingPolicy = .anyInput
        canvasView.isOpaque = false
        canvasView.backgroundColor = UIColor(Color.fsWhite)
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
