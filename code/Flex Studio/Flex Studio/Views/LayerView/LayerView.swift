//
//  LayerView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI
import CoreData
import PencilKit

struct LayerView: UIViewControllerRepresentable {
    @ObservedObject var layer: Layer
    let layerState: LayerState
    
    func makeUIViewController(context: Context) -> LayerViewController {
        let viewController = LayerViewController(layer: layer, state: layerState)
        viewController.layer = layer
        viewController.drawingChanged = { drawing in
            layer.drawing = drawing
        }
        
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: LayerViewController, context: Context) {
        uiViewController.layer = layer
        if layer.drawing != uiViewController.canvasView.drawing {
            // A concurrent version of this layer was updated.
            uiViewController.canvasView.drawing = layer.drawing
        }
        uiViewController.reconfigure()
    }
}
