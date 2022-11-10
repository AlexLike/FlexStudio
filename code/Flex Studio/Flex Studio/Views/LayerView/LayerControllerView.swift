//
//  LayerControllerView.swift
//  Flex Studio
//
//  Created by Tim Kluser on 08.11.22.
//

import SwiftUI

struct LayerControllerView: View {
    
    
    @Environment(\.presentationMode) var presentationMode: Binding<PresentationMode>
    @ObservedObject var panel: Panel
    @State var editingList = false
    @State var selectedLayer:Layer?
    
    init(panel : Panel){
        self.panel = panel
        selectedLayer =  panel.sortedLayers.first
        
    }
    
   /* init(){
        /*UITableView.appearance().tableFooterView=UIView()*/
        /*UITableView.appearance().separatorStyle = .none*/
        print("Hello view")
    }*/
    
    /*override func viewDidLoad(){
        super.viewDidLoad()
        print("debugging")
    }*/
    var body: some View {
        VStack {
            Spacer(minLength: 100)
            
            VStack{
                Text("Layers")
                    .foregroundColor(.black)
                    .padding(.top, 30)
                    .padding(.bottom, 30)
                    .font(.headline)
                
                List{
                    ForEach(panel.sortedLayers){ layer in
                        LayerRow(layer: layer, layerSelected:  self.$selectedLayer)
                            .onTapGesture {
                                self.selectedLayer = layer
                            }
                            
                            
                    }
                    .onMove(perform: move)
                    .onLongPressGesture{
                        withAnimation{
                            self.editingList = true
                        }
                    }
                    
                    
                    
                }
                .listStyle(.plain)
                .listRowBackground(Color.clear)
                .environment(\.editMode, editingList ? .constant(.active) : .constant(.inactive))
                .scrollContentBackground(.hidden)
                
                Button(action: panel.addLayer) {
                    Image(systemName: "plus.circle.fill")
                        .padding(50)
                        .imageScale(.large)
                }
                    
            }
            .background(
                 Rectangle()
                    .foregroundColor(.white)
                    .cornerRadius(200)
             )
            .frame(height: 700)
            
            Spacer(minLength: 100)
        }
    }
    
    func move(fromOffsets source : IndexSet, toOffset destination : Int){
        
        var sortedLayers = panel.sortedLayers
        sortedLayers.move(fromOffsets: source, toOffset: destination)
        
        print("=======1=======")
        print(panel.sortedLayers)
        
        for (i, layer) in sortedLayers.enumerated() {
            layer.order = Int16(i)
        }
        
        panel.objectWillChange.send()
        
        print("=======2=======")
        print(panel.sortedLayers)
        
        withAnimation{
            self.editingList = false
        }
    }
}

struct LayerControllerView_Previews: PreviewProvider {
    static let demoPanel = {
        let p = Panel.create(in: PersistenceLayer.preview.viewContext)
        Layer.create(for: p, order: 1)
        return p
    }()
    
    static var previews: some View {
        NavigationStack {
            LayerControllerView(panel: demoPanel)
        }
        .environment(\.managedObjectContext, PersistenceLayer.preview.viewContext)
    }
}
