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
    
    @Published var selectedLayerOffset: any BinaryInteger = 0
    @Published var selectedTool: EditorTool? = .defaultDraw
    
    // MARK: - PanelView
    
    lazy var magnificationGesture = MagnificationGesture()
        .onChanged { value in
            self.panelScale = self.panelScaleCurrent * value
        }
        .onEnded { _ in
            let newScale = CGFloat.minimum(.maximum(self.panelScale, 0.5), 1.5)
            self.panelScaleCurrent = newScale
            
            withAnimation() {
                self.panelScale = newScale
            }
        }
    
    lazy var canvasWidth: (GeometryProxy, Panel) -> CGFloat? = { proxy, panel in
        guard !proxy.size.height.isZero else { return nil }
        return (panel.size.width / proxy.size.height) * (proxy.size.height * 0.7) + self.dragOffset.width
    }
    
    lazy var canvasHeight: (GeometryProxy, Panel) -> CGFloat? = { proxy, panel in
        guard !proxy.size.height.isZero else { return nil }
        return (panel.size.height / proxy.size.height) * (proxy.size.height * 0.7) + self.dragOffset.height
    }
    
    private func stateForLayer(_ layer: Layer) -> LayerState {
        if layer.order == selectedLayerOffset, let selectedTool {
            return .editable(tool: selectedTool)
        }
        return .static
    }
    
    // MARK: - PanelResizingView
    
    @MainActor
    lazy var rezisingDragGesture: (Edge, GeometryProxy, Panel) -> _EndedGesture<_ChangedGesture<DragGesture>> = { edge, proxy, panel in
        DragGesture(minimumDistance: 0)
            .onChanged { value in
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
            .onEnded { _ in
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
}
