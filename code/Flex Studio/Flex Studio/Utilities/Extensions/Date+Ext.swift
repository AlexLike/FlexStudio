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
        formatter.dateFormat = DateFormatter.dateFormat(fromTemplate: "yyyyMMdd", options: 0, locale: Locale.current)
        return formatter.string(from: self)
    }
}
