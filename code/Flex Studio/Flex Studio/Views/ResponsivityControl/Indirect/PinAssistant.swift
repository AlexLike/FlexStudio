//
//  PinAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import Foundation

protocol PinAssistant: ObservableObject {
    var selectedPinLocation: PinLocation? { get set }
}
