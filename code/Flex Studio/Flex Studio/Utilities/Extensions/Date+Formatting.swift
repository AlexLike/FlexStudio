//
//  Date+Formatting.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import Foundation

extension Date {
    func toString() -> String {
        let date = Date().formatted(date: .abbreviated, time: .shortened)
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }
}
