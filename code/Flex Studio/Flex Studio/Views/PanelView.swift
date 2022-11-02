//
//  PanelView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import SwiftUI

struct PanelView: View {
    /// Layers listed from back to front.
    @State var layers: [Layer]

    @State var selectedLayer: Layer
    @State var selectedTool: EditorTool?
    @State var targetSize: CGSize

    var body: some View {
        ZStack {
            ForEach($layers, id: \.self) { $layer in
                let isSelected = layer == selectedLayer
                LayerView(
                    layer: $layer,
                    state: isSelected ? .selected(tool: selectedTool) : .static,
                    targetSize: targetSize
                )
                .allowsHitTesting(isSelected)
            }
        }
        .toolbar {
            ToolbarItem {
                Button {
                    selectedTool = .debugErase
                } label: { Image(systemName: "eraser") }
            }
            ToolbarItem {
                Button {
                    selectedTool = .debugDraw
                } label: { Image(systemName: "pencil.tip") }
            }
        }
    }

    private func stateForLayer(_ layer: Layer) -> LayerState {
        if layer == selectedLayer, let selectedTool {
            return .editable(tool: selectedTool)
        }
        return .static
    }
}

struct PanelView_Previews: PreviewProvider {
    static let demoLayers = [Layer(), Layer()]
    static var previews: some View {
        NavigationStack {
            PanelView(
                layers: demoLayers,
                selectedLayer: demoLayers[0],
                selectedTool: .debugDraw,
                targetSize: .zero
            )
        }
    }
}
