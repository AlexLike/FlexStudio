//
//  PanelViewModel.swift
//  Flex Studio
//
//  Created by Kai Zheng on 07.11.22.
//

import SwiftUI

class PanelViewModel: ObservableObject {
    // Mode
    
    @Published var responsivityInterfaceVariant: ResponsivityInterfaceVariant = .indirect
    @Published var selectedTool: EditorTool? = .defaultDraw
    private var lruTool: EditorTool?
    
    
    // Display
    
    @Published var aspectProgression: CGFloat = 0.5

    // Panel

    @Published var panelScale: CGFloat = 1
    @Published var panelScaleCurrent: CGFloat = 1

    @Published var dragOffset: CGSize = .zero

    // Layer
    
    @Published var selectedPinLocation: PinLocation? = .loc(.center, .center)
    @Published var selectedLayer: Layer?

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

            withAnimation {
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

    var drawToolPickerState: DrawToolPickerState {
        get { .forEditor(tool: selectedTool) }
        set {
            if let newSelectedTool = EditorTool.fromDrawToolPicker(state: newValue) {
                Task { @MainActor in selectedTool = newSelectedTool }
            }
        }
    }

    var isEditingResponsivity: Bool {
        get { if case .responsivity = selectedTool { return true } else { return false } }
        set {
            if !isEditingResponsivity && newValue {
                lruTool = selectedTool
                selectedTool = .responsivity
            }
            if isEditingResponsivity && !newValue {
                let restorableTool = lruTool
                lruTool = selectedTool
                selectedTool = restorableTool
            }
        }
    }

    // MARK: - PanelResizingView

    @MainActor
    func savePreviewImage(for panel: Panel) {
        UIGraphicsBeginImageContext(panel.size)

        let areaSize = CGRect(origin: .zero, size: panel.size)

        for layer in panel.layers {
            let image = layer.drawing.image(
                from: CGRect(origin: .zero, size: panel.size),
                scale: 1.0
            )
            image.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
        }

        if let allLayersImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            panel.previewImage = allLayersImage
        }
    }
    
    @MainActor
    func savePreviewImage(for layer: Layer, panel: Panel) {
        UIGraphicsBeginImageContext(panel.size)
        
        let areaSize = CGRect(origin: .zero, size: panel.size)

        let image = layer.drawing.image(
            from: CGRect(origin: .zero, size: panel.size),
            scale: 1.0
        )
        image.draw(in: areaSize, blendMode: .normal, alpha: 1.0)

        if let layerImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
            UIGraphicsEndImageContext()
            layer.previewImage = layerImage
        }
    }

    // MARK: - PanelLayerSelectionView

    func move(panel: Panel, fromOffsets source: IndexSet, toOffset destination: Int) {
        var sortedLayers = panel.sortedLayers
        sortedLayers.move(fromOffsets: source, toOffset: destination)

        for (i, layer) in sortedLayers.enumerated() {
            layer.order = Int16(i)
        }
        panel.objectWillChange.send()
    }
}
