//
//  ExecutionEnvironment.swift
//  Flex Studio
//
//  Created by Alexander Zank on 07.11.22.
//

import Foundation

enum ExecutionEnvironment {
    #if targetEnvironment(simulator)
    static let isSimulator = true
    static let is
    #else
    #endif
}
