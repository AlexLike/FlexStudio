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
    @StateObject private var viewModel = PanelViewModel()

    var body: some View {
        ZStack {
            Color.fsGray.edgesIgnoringSafeArea(.all)

            GeometryReader { proxy in
                ZStack {
                    ZStack {
                        Color.fsWhite
                        DrawToolPickerView(state: $viewModel.drawToolPickerState)
                        ForEach(panel.sortedLayers) { layer in
                            let isSelected = layer == viewModel.selectedLayer
                            layer.isVisible ?
                                LayerView(
                                    layer: layer,
                                    state: isSelected ? .selected(tool: viewModel.selectedTool) :
                                        .static
                                )
                                .allowsHitTesting(isSelected)
                                : nil
                        }

                        ZStack {
                            Color.fsGray
                            Rectangle()
                                .frame(
                                    width: viewModel.canvasWidth(proxy, panel),
                                    height: viewModel.canvasHeight(proxy, panel),
                                    alignment: .center
                                )
                                .blendMode(.destinationOut)
                        }
                        .compositingGroup()
                        .allowsHitTesting(false)
                    }
                    .scaleEffect(viewModel.panelScale, anchor: .center)
                    .gesture(viewModel.magnificationGesture)

                    PanelResizingView(panel: panel, viewModel: viewModel, proxy: proxy)
                }
            }

            HStack {
                PanelLayerSelectionView(panel: panel, viewModel: viewModel)
                Spacer()
            }
            .padding(20 /* safeAreainsets.bottom */ )
        }
        .edgesIgnoringSafeArea(.all)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { presentationMode.wrappedValue.dismiss() }) {
                    Image.fsPanels
                }
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
