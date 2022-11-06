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
    @State var selectedTool: EditorTool?
    
    @State private var panelScale: CGFloat = 1
    @State private var panelLastScale: CGFloat = 1
    
    @State private var selectedLayerOffset = 0

    var body: some View {
        ZStack {
            Color.fsGray.edgesIgnoringSafeArea(.all)
            
            ZStack {
                ForEach(panel.sortedLayers) { layer in
                    let isSelected = layer.order == selectedLayerOffset
                    GeometryReader { geometry in
                        let magnificationGesture = MagnificationGesture()
                            .onChanged { panelScale = panelLastScale * $0 }
                            .onEnded { _ in fixScale() }
                        
                        LayerView(
                            layer: layer,
                            state: isSelected ? .selected(tool: selectedTool) : .static,
                            geometry: geometry
                        )
                        .allowsHitTesting(isSelected)
                        .scaleEffect(panelScale, anchor: .center)
                        .gesture(magnificationGesture)
                    }
                }
            }
        }
        .edgesIgnoringSafeArea(.all)
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
    
    private func fixScale() {
        let newScale = CGFloat.minimum(.maximum(panelScale, 0.5), 2)
        panelLastScale = newScale
        
        withAnimation() {
            panelScale = newScale
        }
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
            PanelView(panel: demoPanel, selectedTool: .debugDraw)
        }
    }
}
