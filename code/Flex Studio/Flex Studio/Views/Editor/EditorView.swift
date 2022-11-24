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
            Color.white

            // Layers
            ForEach(viewModel.translationAnnotatedSortedLayers, id: \.0) { layer, translation in
                let isSelected = layer == viewModel.selectedLayer
                LayerView(
                    layer: layer,
                    state: isSelected ?
                        .selected(tool: viewModel.selectedTool) :
                        .static
                )
                .offset(translation)
                .frame(width: Geometry.canvasLength, height: Geometry.canvasLength)
                .allowsHitTesting(isSelected)
                .disabled(!isFullyVisible)
            }
            .layoutPriority(-1)

            // Interactive Anchoring
            switch viewModel.responsivityInterfaceVariant {
            case .indirect:
                ResponsivityOverlayView.indirect(
                    isActive: viewModel.isEditingResponsivity,
                    assistant: viewModel
                )
            case .direct:
                ResponsivityOverlayView.direct(
                    isActive: viewModel.isEditingResponsivity,
                    assistant: viewModel
                )
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
                LayerSelectionView(assistant: viewModel, allowsAddingLayers: !viewModel.isEditingResponsivity)
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
                Button {
                    dismiss()
                    Logger.forStudy.critical("Dismissed EditorView.")
                } label: {
                    Image(systemName: "square.grid.2x2")
                }
            }
        }
        .overlay(StudyControlView(responsivityInterfaceVariant: $viewModel.responsivityInterfaceVariant))
        .navigationTitle(viewModel.panel.title ?? "Panel from \(viewModel.panel.creationDate?.formatted(date: .abbreviated, time: .shortened) ?? "some date")")
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .onAppear {
            viewModel.selectedLayer = viewModel.panel.layers.first!
            isFullyVisible = true
        }
        .onDisappear {
            viewModel.panel.updateThumbnail(variant: viewModel.responsivityInterfaceVariant)
        }
    }
}

struct EditorView_Previews: PreviewProvider {
    static var previews: some View {
        EditorView(panel: .create(in: PersistenceLayer.preview.viewContext))
            .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
