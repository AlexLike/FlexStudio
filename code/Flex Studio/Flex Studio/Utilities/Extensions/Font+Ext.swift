//
//  Font+Ext.swift
//  Flex Studio
//
//  Created by Kai Zheng on 06.11.22.
//

import SwiftUI

extension Font {
    static let fs_header = custom("Inter-SemiBold", size: 36)
    static let fs_title = custom("Inter-Medium", size: 20)
    static let fs_subtitle = custom("Inter-Medium", size: 17)
    static let fs_text = custom("Inter-Regular", size: 15)
}

extension UIFont {
    static let fs_header = UIFont(name: "Inter-SemiBold", size: 36)
    static let fs_title = UIFont(name: "Inter-Medium", size: 20)
}
