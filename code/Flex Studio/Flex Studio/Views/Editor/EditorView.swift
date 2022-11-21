//
//  EditorView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 01.11.22.
//

import SwiftUI

struct EditorView: View {
    @Environment(\.dismiss) var dismiss: DismissAction
    @StateObject var viewModel: EditorViewModel
    @State var isFullyVisible = false

    init(panel: Panel) {
        _viewModel = StateObject(wrappedValue: EditorViewModel(panel: panel))
    }

    var body: some View {
        ZStack {
            // Paper Background
            Color.fsWhite

            // Layers
            ForEach(viewModel.translationAnnotatedSortedLayers, id: \.0) { (layer, translation) in
                let isSelected = layer == viewModel.selectedLayer
                LayerView(
                    layer: layer,
                    state: isSelected ?
                        .selected(tool: viewModel.selectedTool) :
                        .static
                )
                .offset(translation)
                .frame(width: Dimensions.canvasLength, height: Dimensions.canvasLength)
                .allowsHitTesting(isSelected)
                .opacity(layer.isVisible ? 1 : 0)
                .disabled(!isFullyVisible)
            }
            .layoutPriority(-1)

            // Frame
            FrameView(
                aspectProgression: $viewModel.aspectProgression,
                isResizable: viewModel.isEditingResponsivity
            )

            // Tools
            DrawToolPickerView(state: $viewModel.drawToolPickerState)
                .allowsHitTesting(false)
            HStack {
                LayerSelectionView(viewModel: viewModel)
                Spacer()
                VStack {
                    Spacer()
                    Group {
                        switch viewModel.responsivityInterfaceVariant {
                        case .indirect:
                            ResponsivityControlView.indirect(
                                isExpanded: $viewModel.isEditingResponsivity,
                                assistant: viewModel
                            )
                        case .direct:
                            ResponsivityControlView.direct(
                                isExpanded: $viewModel.isEditingResponsivity,
                                assistant: viewModel
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
        .navigationTitle("Panel \(viewModel.panel.creationDate?.toString() ?? Date.nilString)")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.selectedLayer = viewModel.panel.layers.first!
            isFullyVisible = true
        }
        .onDisappear {
            viewModel.savePreviewImage()
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(panel: .create(in: PersistenceLayer.preview.viewContext))
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
