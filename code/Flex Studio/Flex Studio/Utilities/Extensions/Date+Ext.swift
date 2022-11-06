//
//  Date+Ext.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import Foundation

extension Date {
    static let nilString: String = "This shouldn't be!"
    
    func toString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter.string(from: self)
    }
}
