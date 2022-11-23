//
//  UIWindow+Swizzle.swift
//  Flex Studio
//
//  Created by Alexander Zank on 23.11.22.
//

import UIKit

extension UIWindow {
    func swizzle() {
        let sendEvent = class_getInstanceMethod(
            object_getClass(self),
            #selector(UIApplication.sendEvent(_:))
        )
        let swizzledSendEvent = class_getInstanceMethod(
            object_getClass(self),
            #selector(UIWindow.swizzledSendEvent(_:))
        )
        method_exchangeImplementations(sendEvent!, swizzledSendEvent!)
    }

    @objc func swizzledSendEvent(_ event: UIEvent) {
        if event.type == .touches { handle(event.allTouches!) }
        swizzledSendEvent(event)
    }

    func handle(_ touches: Set<UITouch>) {
        for touch in touches {
            if case .ended = touch.phase {
                Logger.forStudy
                    .critical("Touch ended at \("\(touch.location(in: nil))", privacy: .public)")
            }
        }
    }
}
