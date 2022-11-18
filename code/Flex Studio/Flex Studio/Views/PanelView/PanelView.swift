//
//  PanelView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import SwiftUI

struct PanelView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    @ObservedObject var panel: Panel
    @StateObject private var viewModel = PanelViewModel()

    var body: some View {
        ZStack {
            // Paper Background
            Color.fsWhite

            // Layers
            ForEach(panel.sortedLayers) { layer in
                let isSelected = layer == viewModel.selectedLayer
                LayerView(
                    layer: layer,
                    state: isSelected ?
                        .selected(tool: viewModel.selectedTool) :
                        .static
                )
                .allowsHitTesting(isSelected)
                .opacity(layer.isVisible ? 1 : 0)
            }

            // Frame
            FrameView(
                aspectProgression: $viewModel.aspectProgression,
                isResizable: viewModel.isEditingResponsivity
            )

            // Tools
            DrawToolPickerView(state: $viewModel.drawToolPickerState)
                .allowsHitTesting(false)
            HStack {
                PanelLayerSelectionView(panel: panel, viewModel: viewModel)
                Spacer()
                VStack {
                    Spacer()
                    Group {
                        switch viewModel.responsivityInterfaceVariant {
                        case .indirect:
                            ResponsivityControlView.indirect(
                                isExpanded: $viewModel.isEditingResponsivity,
                                selectedLocation: $viewModel.selectedPinLocation
                            )
                        case .direct:
                            ResponsivityControlView.direct(
                                isExpanded: $viewModel.isEditingResponsivity
                            )
                        }
                    }
                    .padding([.bottom, .top, .trailing], 29)
                }
            }
            .padding(20 /* safeAreainsets.bottom */ )
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }, label: {
                    Image.fsPanels
                })
            }
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) { // Sidebar menu functionality
                    Image.fsSidemenu
                }
            }
        }
        .navigationTitle("Panel \(panel.creationDate?.toString() ?? Date.nilString)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.selectedLayer = panel.layers.first
        }
        .onDisappear {
            viewModel.savePreviewImage(panel: panel)
        }
    }
}

struct Panels_Previews: PreviewProvider {
    static var previews: some View {
        PanelView(panel: .create(in: PersistenceLayer.preview.viewContext))
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
