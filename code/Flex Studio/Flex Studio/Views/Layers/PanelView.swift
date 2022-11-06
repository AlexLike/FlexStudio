//
//  PanelView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import SwiftUI

struct PanelView: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var panel: Panel
    @State var selectedLayerOffset = 0
    @State var selectedTool: EditorTool?
    @State var targetSize: CGSize

    var body: some View {
        ZStack {
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
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image.fsPanels
                }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {  }) { // Sidebar menu functionality
                    Image.fsSidemenu
                }
            }
        }
        .navigationTitle("Panel \(panel.creationDate?.toString() ?? Date.nilString)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
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
