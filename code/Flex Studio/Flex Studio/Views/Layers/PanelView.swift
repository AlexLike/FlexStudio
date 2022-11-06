//
//  PanelView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import SwiftUI

struct PanelView: View {
    @ObservedObject var panel: Panel
    @State var selectedLayerOffset = 0
    @State var selectedTool: EditorTool?
    @State var targetSize: CGSize

    var body: some View {
        ZStack {
            ForEach(panel.sortedLayers) { layer in
                let isSelected = layer.order == selectedLayerOffset
                LayerView(
                    layer: layer,
                    state: isSelected ? .selected(tool: selectedTool) : .static
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
        .navigationTitle("Panel \(panel.uid)")
        .navigationBarTitleDisplayMode(.inline)
    }

    private func stateForLayer(_ layer: Layer) -> LayerState {
        if layer.order == selectedLayerOffset, let selectedTool {
            return .editable(tool: selectedTool)
        }
        return .static
    }
}

struct PanelView_Previews: PreviewProvider {
    static let demoPanel = {
        let p = Panel.create(in: PersistenceLayer.preview.viewContext)
        Layer.create(for: p, order: 1)
        return p
    }()

    static var previews: some View {
        NavigationStack {
            PanelView(
                panel: demoPanel,
                selectedTool: .debugDraw,
                targetSize: .zero
            )
        }
    }
}
