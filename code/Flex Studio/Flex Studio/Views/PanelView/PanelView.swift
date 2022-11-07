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
                ZStack(/*alignment: .init(horizontal: .leadingResizingAlignment, vertical: .center)*/) {
                    ZStack {
                        ForEach(panel.sortedLayers) { layer in
                            let isSelected = layer.order == viewModel.selectedLayerOffset && viewModel.panelState == .static
                            LayerView(
                                layer: layer,
                                layerState: isSelected ? .selected(tool: viewModel.selectedTool) : .static
                            )
                            .allowsHitTesting(isSelected)
                        }
                        .background(Color.fsWhite)
                        
                        ZStack {
                            Color.fsGray
                            Rectangle()
                                .frame(width: viewModel.canvasWidth(proxy, panel), height: viewModel.canvasHeight(proxy, panel), alignment: .center)
                                .blendMode(.destinationOut)
//                                .alignmentGuide(.leadingResizingAlignment, computeValue: { $0[.leading] })
                        }
                        .compositingGroup()
                        .allowsHitTesting(false)
                    }
                    .scaleEffect(viewModel.panelScale, anchor: .center)
                    .gesture(viewModel.magnificationGesture)
                    
                    PanelResizingView(panel: panel, viewModel: viewModel, proxy: proxy)
                }
            }
            
            // Layers Selection View here
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
        .onDisappear {
            viewModel.savePreviewImage(panel: panel)
        }
    }
}
