//
//  PanelsView.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

struct PanelsView: View {
    @StateObject var viewModel = PanelsViewModel()
    
    var body: some View {
        ZStack {
            Color.fs_background.edgesIgnoringSafeArea(.all)
            
            ScrollView(showsIndicators: false) {
                LazyVGrid(columns: viewModel.itemColumns, spacing: .fs_padding_large) {
                    ForEach(viewModel.panels) { panel in
                        NavigationLink(destination: PanelView(panel: panel, selectedTool: .debugDraw, targetSize: .zero)) {
                            PanelItemView(panel: panel)
                        }
                        .fs_buttonStyleScale()
                    }
                    
                    Button(action: { viewModel.addItem() }) {
                        AddItemView()
                    }
                    .fs_buttonStyleScale()
                }
                .padding(.fs_padding_medium)
                .padding(.bottom, .fs_padding_large)
            }
        }
        .navigationTitle("Panels")
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {}) {
                    Text("Select") // TODO: - Implement selecting logic
                }
            }
        }
    }
    
    private struct PanelItemView: View {
        @ObservedObject var panel: Panel
        
        var body: some View {
            VStack(spacing: .fs_padding_medium) {
                Color.clear // TODO: - Image Snapshot of Panel
                    .background(Color.fs_white)
                    .frame(height: 240) // TODO: - Dynamic height based on Panel
                    .cornerRadius(10)
                
                // TODO: - Number in Comic (in final product)
                Text("\(panel.creationDate?.toString() ?? Date.nilString)")
                    .font(.fs_subtitle)
                    .foregroundColor(.gray)
            }
        }
    }
    
    private struct AddItemView: View {
        var body: some View {
            VStack {
                RoundedRectangle(cornerRadius: 15)
                    .stroke(Color.fs_gray, style: StrokeStyle(lineWidth: 4, dash: [15.0]))
                    .frame(height: 240)
                    .cornerRadius(10)
                    .overlay(
                        VStack(spacing: .fs_padding_small) {
                            Image.fs_paint
                                .font(.system(size: 32))
                                .foregroundColor(.fs_gray)
                            Text("New panel")
                                .font(.fs_subtitle)
                                .foregroundColor(.fs_gray)
                        }
                    )
                
                Spacer()
            }
        }
    }
}
