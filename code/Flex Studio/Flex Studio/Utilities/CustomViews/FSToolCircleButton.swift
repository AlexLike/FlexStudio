//
//  FSToolCircle.swift
//  Flex Studio
//
//  Created by Kai Zheng on 07.11.22.
//

import SwiftUI

struct FSToolCircleButton: View {
    @State private var selected: Bool = false
    let symbol: Image
    let action: (Bool) -> ()
    
    var body: some View {
        Button(action: {
            selected.toggle()
            action(selected)
        }) {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(selected ? Color.fsTint : Color.fsBackground)
                .shadow(radius: 10)
                .overlay(
                    symbol
                        .font(.system(size: 20))
                        .foregroundColor(selected ? Color.fsBackground : Color.fsDarkGray)
                )
        }
        .fsButtonStyleScale()
    }
}
