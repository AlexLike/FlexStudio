//
//  LayerSelectionAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 22.11.22.
//

import Foundation

protocol LayerSelectionAssistant: ObservableObject {
    var selectedLayer: Layer { get set }
    var sortedLayers: [Layer] { get }
    
    func createLayer()
    func deleteLayer(_ layer: Layer)
    func moveLayers(from offsets: IndexSet, to target: Int)
}
