
//
//  PinMenuView.swift
//  Flex Studio
//
//  Created by Karl Robert Kristenprun on 16.11.2022.
//

import SwiftUI

struct PinButton: View {
    let responsibleState: LayerPinState
    @Binding var state: LayerPinState
    
    var body: some View {
        Button(action: onClick){
            Image(systemName: state == responsibleState ? "pin.circle" : "circle")
                .font(.system(size: state == responsibleState ? 25 : 20))
                .foregroundColor(state == responsibleState ? .fsBlack : .fsDarkGray)
                .frame(width: 45, height: 45)
        }
    }
    
    func onClick() {
        state = responsibleState
    }
    
}
struct PinMenuView: View {
    @Binding var state: LayerPinState
    
    var body: some View {
        Grid() {
            GridRow{
                PinButton(responsibleState: .ur, state: $state)
                PinButton(responsibleState: .um, state: $state)
                PinButton(responsibleState: .ul, state: $state)
            }
            
            GridRow{
                PinButton(responsibleState: .mr, state: $state)
                PinButton(responsibleState: .mm, state: $state)
                PinButton(responsibleState: .ml, state: $state)
            }
            
            GridRow{
                PinButton(responsibleState: .br, state: $state)
                PinButton(responsibleState: .bm, state: $state)
                PinButton(responsibleState: .bl, state: $state)
            }
        }
        .frame(width: 200, height: 210)
        .background(Color.fsWhite)
        .cornerRadius(50)
        .shadow(color: .black.opacity(0.1), radius: 10)
    }
}

struct PinMenuView_Previews: PreviewProvider {
    
    struct Container: View {
        
        @State var state: LayerPinState = .ul
        var body: some View{
            PinMenuView(state: $state)
        }
    }
    static var previews: some View {
        Container()
    }
    
}
