//
//  Font+Ext.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

extension Font {
    static let fsHeader = custom("Inter-SemiBold", size: 36, relativeTo: .largeTitle)
    static let fsTitle = custom("Inter-Medium", size: 20, relativeTo: .title)
    static let fsSubtitle = custom("Inter-Medium", size: 17, relativeTo: .subheadline)
    static let fsBody = custom("Inter-Regular", size: 15, relativeTo: .body)
}

extension UIFont {
    static let fs_header = UIFont(name: "Inter-SemiBold", size: 36)
    static let fs_title = UIFont(name: "Inter-Medium", size: 20)
}
