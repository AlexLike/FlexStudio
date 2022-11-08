//
//  ExecutionEnvironment.swift
//  Flex Studio
//
//  Created by Alexander Zank on 07.11.22.
//

import Foundation

enum ExecutionEnvironment {
    #if targetEnvironment(simulator)
    static let isPreview = ProcessInfo.processInfo
         .environment["XCODE_RUNNING_FOR_PREVIEWS"] == "1"
    #else
    static let isPreview = false
    #endif
}
