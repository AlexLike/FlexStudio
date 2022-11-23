//
//  EditorViewModel+LayerSelectionAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 22.11.22.
//

import Foundation

extension EditorViewModel: LayerSelectionAssistant {
    
    var sortedLayers: [Layer] {
        panel.sortedLayers
    }
    
    func createLayer() {
        Layer.create(for: panel, order: Int16(panel.layers.count))
    }
    
    func deleteLayer(_ layer: Layer) {
        let order = layer.order
        let wasSelected = selectedLayer == layer
        
        layer.delete(removingFromPanel: true)
        
        if wasSelected {
            selectedLayer = sortedLayers[max(0, Int(order)-1)]
        }
        
        for layer in panel.layers where order >= order {
            layer.order -= 1
        }
    }
    
    func moveLayers(from offsets: IndexSet, to target: Int) {
        var sortedLayers = panel.sortedLayers
        sortedLayers.move(fromOffsets: offsets, toOffset: target)

        for (i, layer) in sortedLayers.enumerated() {
            layer.order = Int16(i)
        }
    }
}
