//
//  Logger.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import OSLog

enum Logger {
    static func forType<T>(_ type: T.Type) -> os.Logger {
        os.Logger(subsystem: Bundle.main.bundleIdentifier!, category: String(describing: type))
    }
}
