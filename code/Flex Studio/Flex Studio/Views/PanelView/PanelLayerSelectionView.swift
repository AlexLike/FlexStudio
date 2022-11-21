//
//  PanelLayerSelectionView.swift
//  Flex Studio
//
//  Created by Tim Kluser on 08.11.22.
//

import SwiftUI

struct PanelLayerSelectionView: View {
    @ObservedObject var panel: Panel
    @ObservedObject var viewModel: PanelViewModel
    
    var body: some View {
        VStack {
            Text("Layers")
                .font(.fsTitle)
                .foregroundColor(.fsBlack)
                .padding(.top, 50)
                .padding(.bottom, .fsPaddingMedium)
            
            List {
                ForEach(panel.sortedLayers) { layer in
                    LayerRow(panel: panel, layer: layer, viewModel: viewModel)
                        .swipeActions(allowsFullSwipe: false){
                            Button {
                                panel.deleteLayer(layer: layer)
                            } label: {
                                Label("Mute", systemImage: "trash")
                            }
                            .tint(.red)
                        }
                }
                .onMove(perform: { viewModel.move(panel: panel, fromOffsets: $0, toOffset: $1) })
                .listRowBackground(Color.clear)
                .listRowSeparator(.hidden)
                .listRowInsets(.init(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            
            Button(action: panel.addLayer) {
                Image(systemName: "plus.circle.fill")
                    .font(.system(size: 32))
                    .foregroundColor(.fsGray)
                    .padding(.top, .fsPaddingMedium)
                    .padding(.bottom, 50)
            }
        }
        .frame(width: 150, height: 500)
        .background(Color.fsBackground)
        .cornerRadius(75)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
    
    private struct LayerRow: View {
        @ObservedObject var panel: Panel
        @ObservedObject var layer: Layer
        @ObservedObject var viewModel: PanelViewModel
        
        var body: some View {
            ZStack {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: 70)
                    .foregroundColor(viewModel.selectedLayer == layer ? .fsGray : .clear)
                
                HStack{
                    Image(uiImage: layer.previewImage ?? UIImage())
                        .resizable()
                        .frame(width: 55, height: 55)
                        .background(Color.fsWhite)
                        .cornerRadius(5)
                        .clipped()
                    
                    Spacer()
                    
                    Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                        .font(.system(size: 14))
                        .foregroundColor(.fsDarkGray)
                        .highPriorityGesture(TapGesture().onEnded {
                            layer.isVisible.toggle()
                            panel.objectWillChange.send()
                        })
                }
                .padding(.horizontal, 7.5)
            }
            .padding(.vertical, .fsPaddingSmall)
            .padding(.horizontal, 2 * .fsPaddingSmall)
            .onTapGesture {
                viewModel.selectedLayer = layer
                panel.objectWillChange.send()
            }
        }
    }
}
