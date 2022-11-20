//
//  EditorViewModel+PinAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 20.11.22.
//

import Foundation

extension EditorViewModel: PinAssistant {
    var selectedPinLocation: PinLocation? {
        get { selectedLayer.pinLocation }
        set { selectedLayer.pinLocation = newValue }
    }
    
    
}
