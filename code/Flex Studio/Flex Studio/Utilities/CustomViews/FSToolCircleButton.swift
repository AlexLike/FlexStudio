//
//  FSToolCircle.swift
//  Flex Studio
//
//  Created by Kai Zheng on 07.11.22.
//

import SwiftUI

struct FSToolCircleButton: View {
    let symbol: Image
    @Binding var isSelected: Bool
    
    var body: some View {
        Button {
            isSelected.toggle()
        } label: {
            Circle()
                .frame(width: 60, height: 60)
                .foregroundColor(isSelected ? Color.fsTint : Color.fsBackground)
                .shadow(color: .black.opacity(0.1), radius: 10)
                .overlay(
                    symbol
                        .font(.system(size: 20))
                        .foregroundColor(isSelected ? Color.fsWhite : Color.fsDarkGray)
                )
        }
        .fsButtonStyleScale()
    }
}
