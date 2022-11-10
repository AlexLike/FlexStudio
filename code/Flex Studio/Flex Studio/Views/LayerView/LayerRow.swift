//
//  LayerRow.swift
//  Flex Studio
//
//  Created by Tim Kluser on 08.11.22.
//


import SwiftUI
import PencilKit

struct LayerRow: View {
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var layer: Layer
    var canvasView = PKCanvasView()
    @State var showLayer = Bool(false)
    @Binding var layerSelected :Layer? // is selected for drawing?
    
    var body: some View {
            ZStack{
                Rectangle()
                    .frame(width: 200, height: 70)
                    .cornerRadius(30)
                    .foregroundColor(layerSelected == self.layer ?.gray:.white)
                    .opacity(0.5)
                HStack{
                    Rectangle()
                        .frame(width: 80, height: 60)
                        .clipShape(
                            Capsule()
                        )
                        .foregroundColor(.black)
                        .overlay(
                            Text(String(layer.order)).foregroundColor(.white)
                        )
                    
                    
                    Image(systemName: layer.isVisible ? "eye.fill" : "eye.slash")
                        .onTapGesture {
                            layer.isVisible.toggle()
                        }
                        .padding(.horizontal, 20)
                    
                        
                }
                
                    
                
                
            }
            .onTapGesture {
                layerSelected = layer
            }
        
        
            
        
    }
}

// don't know how to pass a binding in a preview

//struct LayerRow_Previews: PreviewProvider {
//    static let demoPanel = {
//        let p = Panel.create(in: PersistenceLayer.preview.viewContext)
//        Layer.create(for: p, order: 1)
//        return p
//    }()
//
//    @State var layer : Layer? = demoPanel.sortedLayers[0]
//    static var previews: some View {
//        NavigationStack {
//            LayerRow(layer: layer, layerSelected: $layer)
//        }
//    }
//}
