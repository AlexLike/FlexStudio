//
//  UIWindow+Swizzle.swift
//  Flex Studio
//
//  Created by Alexander Zank on 23.11.22.
//

import UIKit

extension UIWindow {
    static let logger = Logger.forType(UIWindow.self)
    static let swizzledWindows = NSHashTable<UIWindow>(options: .weakMemory)
    
    func swizzle() {
        guard !Self.swizzledWindows.contains(self) else {
            Self.logger.notice("Attempted to un-swizzle a window. Ignoring request.")
            return
        }
        
        let sendEvent = class_getInstanceMethod(
            object_getClass(self),
            #selector(UIApplication.sendEvent(_:))
        )
        let swizzledSendEvent = class_getInstanceMethod(
            object_getClass(self),
            #selector(UIWindow.swizzledSendEvent(_:))
        )
        method_exchangeImplementations(sendEvent!, swizzledSendEvent!)
        
        Self.logger.notice("Successfully swizzled the window.")
        Self.swizzledWindows.add(self)
    }

    @objc func swizzledSendEvent(_ event: UIEvent) {
        if event.type == .touches { handle(event.allTouches!) }
        swizzledSendEvent(event)
    }

    func handle(_ touches: Set<UITouch>) {
        for touch in touches {
            if case .began = touch.phase {
                Logger.forStudy
                    .critical("Touch began at \("\(touch.location(in: nil))", privacy: .public)")
            }
        }
    }
}
