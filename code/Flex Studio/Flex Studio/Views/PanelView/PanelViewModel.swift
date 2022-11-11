//
//  PanelViewModel.swift
//  Flex Studio
//
//  Created by Kai Zheng on 07.11.22.
//

import SwiftUI

class PanelViewModel: ObservableObject {
    // Panel
    
    @Published var panelScale: CGFloat = 1
    @Published var panelScaleCurrent: CGFloat = 1
    
    @Published var panelState: PanelState = .static
    @Published var dragOffset: CGSize = .zero
    
    // Layer
    
    @Published var selectedLayer: Layer?
    @Published var selectedTool: EditorTool? = .defaultDraw
    
    // MARK: - PanelView
    
    lazy var magnificationGesture = MagnificationGesture()
        .onChanged { [weak self] value in
            guard let self = self else { return }
            self.panelScale = self.panelScaleCurrent * value
        }
        .onEnded { [weak self] _ in
            guard let self = self else { return }
            let newScale = CGFloat.minimum(.maximum(self.panelScale, 0.5), 1.5)
            self.panelScaleCurrent = newScale
            
            withAnimation() {
                self.panelScale = newScale
            }
        }
    
    lazy var canvasWidth: (GeometryProxy, Panel) -> CGFloat? = { [weak self] proxy, panel in
        guard let self = self else { return nil }
        guard !proxy.size.height.isZero else { return nil }
        return (panel.size.width / 1000) * (1000 * 0.7) + self.dragOffset.width
    }
    
    lazy var canvasHeight: (GeometryProxy, Panel) -> CGFloat? = { [weak self] proxy, panel in
        guard let self = self else { return nil }
        guard !proxy.size.height.isZero else { return nil }
        return (panel.size.height / 1000) * (1000 * 0.7) + self.dragOffset.height
    }
    
    private func stateForLayer(_ layer: Layer) -> LayerState {
        if layer == selectedLayer, let selectedTool {
            return .editable(tool: selectedTool)
        }
        return .static
    }
    
    // MARK: - PanelResizingView
    
    @MainActor
    lazy var rezisingDragGesture: (Edge, GeometryProxy, Panel) -> _EndedGesture<_ChangedGesture<DragGesture>> = { edge, proxy, panel in
        DragGesture(minimumDistance: 0)
            .onChanged { [weak self] value in
                guard let self = self else { return }
//                guard panel.size.width + abs(value.translation.width) < proxy.size.width - 200 else { return }
//                guard panel.size.width - abs(value.translation.width) >= Panel.minSize.width else { return }
//                
//                guard panel.size.height + abs(value.translation.height) < proxy.size.height - 200 else { return }
//                guard panel.size.height - abs(value.translation.height) >= Panel.minSize.height else { return }
                    
                switch edge {
                case .leading, .trailing:
                    self.dragOffset.width = value.translation.width
                case .top, .bottom:
                    self.dragOffset.height = value.translation.height
                }
                
                self.panelState = .onResize(onDrag: true)
            }
            .onEnded { [weak self] _ in
                guard let self = self else { return }
                self.updateSize(panel, with: self.dragOffset)
                self.dragOffset = .zero
                self.panelState = .onResize(onDrag: false)
            }
    }

    @MainActor
    private func updateSize(_ panel: Panel, with offset: CGSize) {
        panel.width_ = panel.width_ + Float(offset.width)
        panel.height_ = panel.height_ + Float(offset.height)
        PersistenceLayer.shared.save()
    }
    
    @MainActor
    func savePreviewImage(panel: Panel) {
        UIGraphicsBeginImageContext(panel.size)
        
        let areaSize = CGRect(origin: .zero, size: panel.size) // TODO: - Find out center point of all layers
        
        for layer in panel.layers {
            let image = layer.drawing.image(from: CGRect(origin: .zero, size: panel.size), scale: 1.0)
            image.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        }
        
        let allLayersImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        panel.previewImage = allLayersImage
    }
    
    // MARK: - PanelLayerSelectionView
    
    func move(panel: Panel, fromOffsets source : IndexSet, toOffset destination : Int){
        var sortedLayers = panel.sortedLayers
        sortedLayers.move(fromOffsets: source, toOffset: destination)
        
        for (i, layer) in sortedLayers.enumerated() {
            layer.order = Int16(i)
        }
        panel.objectWillChange.send()
    }
}
