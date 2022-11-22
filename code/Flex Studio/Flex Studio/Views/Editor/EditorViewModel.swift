//
//  EditorViewModel.swift
//  Flex Studio
//
//  Created by Kai Zheng & Alexander Zank on 07.11.22.
//

import Combine
import SwiftUI

/// A service for manipulating a given panel.
class EditorViewModel: ObservableObject {
    /// The panel this editor is manipulating.
    let panel: Panel

    /// The currently employed undelying responsivity concept.
    @Published var responsivityInterfaceVariant: ResponsivityInterfaceVariant = .direct

    /// The currrently active tool.
    @Published var selectedTool: EditorTool? = .defaultDraw
    private var lruTool: EditorTool?

    /// A value ∈ [0,1] that linearizes the panel's aspect ration, i.e. it linearly interpolates
    /// width ∈ [0,0.5] and height ∈ [0.5,1].
    /// - A value of 0.5 corresponds to a 1:1 aspect ratio.
    /// - A value of 0 corresponds to a 2:1 aspect ratio.
    /// - A value of 1 corresponds to a 1:2 aspect ratio.
    @Published var aspectProgression: CGFloat = 0.5

    /// The layer being currently manipulated.
    @Published var selectedLayer: Layer {
        willSet {
            selectedLayerSubscription = newValue.objectWillChange
                .sink { self.objectWillChange.send() }
        }
    }

    /// An array of layers with their computed translations for the current aspectProgression under
    /// the current responsivityInterfaceVariant.
    var translationAnnotatedSortedLayers: [(Layer, CGSize)] {
        switch responsivityInterfaceVariant {
        case .indirect:
            return panel.sortedLayers
                .map { (
                    $0,
                    Geometry.computeIndirectTranslation(
                        for: $0,
                        at: aspectProgression
                    )
                ) }
        case .direct:
            return panel.sortedLayers.map { (
                $0,
                Geometry.computeDirectTranslation(
                    for: $0,
                    at: aspectProgression
                )
            ) }
        }
    }

    private var panelSubscription: AnyCancellable?
    private var selectedLayerSubscription: AnyCancellable?

    init(panel: Panel) {
        self.panel = panel
        selectedLayer = panel.sortedLayers.last!
        panelSubscription = panel.objectWillChange.sink { self.objectWillChange.send() }
    }

    // MARK: - EditorView

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
            if !isEditingResponsivity, newValue {
                lruTool = selectedTool
                selectedTool = .responsivity
            }
            if isEditingResponsivity, !newValue {
                let restorableTool = lruTool
                lruTool = selectedTool
                selectedTool = restorableTool
            }
        }
    }

    // MARK: - PanelResizingView

//    @MainActor
//    func savePreviewImage() {
//        UIGraphicsBeginImageContext(panel.size)
//
//        let areaSize = CGRect(origin: .zero, size: panel.size)
//
//        for layer in panel.layers {
//            let image = layer.drawing.image(
//                from: CGRect(origin: .zero, size: panel.size),
//                scale: 1.0
//            )
//            image.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
//        }
//
//        if let allLayersImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
//            UIGraphicsEndImageContext()
//            panel.previewImage = allLayersImage
//        }
//    }
//
//    @MainActor
//    func savePreviewImage(for layer: Layer) {
//        UIGraphicsBeginImageContext(panel.size)
//
//        let areaSize = CGRect(origin: .zero, size: panel.size)
//
//        let image = layer.drawing.image(
//            from: CGRect(origin: .zero, size: panel.size),
//            scale: 1.0
//        )
//        image.draw(in: areaSize, blendMode: .normal, alpha: 1.0)
//
//        if let layerImage: UIImage = UIGraphicsGetImageFromCurrentImageContext() {
//            UIGraphicsEndImageContext()
//            layer.previewImage = layerImage
//        }
//    }

    // MARK: - LayerSelectionView

    func move(fromOffsets source: IndexSet, toOffset destination: Int) {
        var sortedLayers = panel.sortedLayers
        sortedLayers.move(fromOffsets: source, toOffset: destination)

        for (i, layer) in sortedLayers.enumerated() {
            layer.order = Int16(i)
        }
        panel.objectWillChange.send()
    }
}
