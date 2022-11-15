//
//  DrawToolPickerView.swift
//  Flex Studio
//
//  Created by Alexander Zank on 15.11.22.
//

import SwiftUI
import PencilKit

struct DrawToolPickerView: UIViewRepresentable {
    @Binding var state: DrawToolPickerState
    
    static let picker = PKToolPicker()
    
    func makeCoordinator() -> DrawToolManager {
        DrawToolManager(servicedView: self)
    }
    
    func makeUIView(context: Context) -> UIView {
        let target = Target()
        Self.picker.setVisible(true, forFirstResponder: target)
        Self.picker.addObserver(context.coordinator)
        Self.picker.showsDrawingPolicyControls = false
        reconfigure(target)
        return target
    }
    
    func updateUIView(_ target: UIView, context: Context) {
        reconfigure(target)
    }
    
    private func reconfigure(_ target: UIView) {
        switch state {
        case .hidden:
            Task { @MainActor in target.resignFirstResponder() }
        case .pick(let tool, let isRulerAcive):
            Self.picker.selectedTool = tool
            Self.picker.isRulerActive = isRulerAcive
            Task { @MainActor in target.becomeFirstResponder() }
        }
    }
    
    static func dismantleUIView(_ target: UIView, coordinator: DrawToolManager) {
        Self.picker.setVisible(false, forFirstResponder: target)
        Self.picker.removeObserver(coordinator)
    }
    
    class Target: UIView {
        override var canBecomeFirstResponder: Bool { true }
    }
    
    class DrawToolManager: NSObject, PKToolPickerObserver {
        let servicedView: DrawToolPickerView
        
        init(servicedView: DrawToolPickerView) {
            self.servicedView = servicedView
        }
        
        func toolPickerSelectedToolDidChange(_ picker: PKToolPicker) {
            if case .pick(_, let isRulerActive) = servicedView.state {
                servicedView.state = .pick(tool: picker.selectedTool, isRulerActive: isRulerActive)
            }
        }
        
        func toolPickerIsRulerActiveDidChange(_ toolPicker: PKToolPicker) {
            if case .pick(let tool, _) = servicedView.state {
                servicedView.state = .pick(tool: tool, isRulerActive: picker.isRulerActive)
            }
        }
    }
}
