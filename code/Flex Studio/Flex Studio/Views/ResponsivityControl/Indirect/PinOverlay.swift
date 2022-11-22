//
//  PinOverlay.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import SwiftUI

struct PinOverlay<A: PinAssistant>: ResponsivityOverlay {
    let assistant: A
    
    var body: some View {
        EmptyView()
    }
}
