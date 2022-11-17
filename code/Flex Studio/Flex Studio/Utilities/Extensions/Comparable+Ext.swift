//
//  Comparable+Ext.swift
//  Flex Studio
//
//  Created by Alexander Zank on 16.11.22.
//

import Foundation

extension Comparable {
    func clamped(to range: ClosedRange<Self>) -> Self {
        return min(max(self, range.lowerBound), range.upperBound)
    }
}
