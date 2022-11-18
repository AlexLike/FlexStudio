//
//  PinLocation.swift
//  Flex Studio
//
//  Created by Karl Robert Kristenprun on 17.11.2022.
//

import Foundation

enum PinLocation: CaseIterable, Equatable, Identifiable, CustomStringConvertible {
    case loc(_ vertical: VerticalComponent, _ horizontal: HorizontalComponent)

    enum VerticalComponent: Int8, CustomStringConvertible {
        case top, center, bottom
        
        var description: String {
            switch self {
            case .top: return "top"
            case .center: return "center"
            case .bottom: return "bottom"
            }
        }
    }

    enum HorizontalComponent: Int8 {
        case left, center, right
        
        var description: String {
            switch self {
            case .left: return "left"
            case .center: return "center"
            case .right: return "right"
            }
        }
    }

    static var allCases: [PinLocation] { [
        .loc(.top, .left), .loc(.top, .center), .loc(.top, .right),
        .loc(.center, .left), .loc(.center, .center), .loc(.center, .right),
        .loc(.bottom, .left), .loc(.bottom, .center), .loc(.bottom, .right),
    ] }

    var id: Int8 {
        if case let .loc(v, h) = self { return 3 * v.rawValue + h.rawValue }
        else { return -1 }
    }
    
    var description: String {
        if case let .loc(v, h) = self {
            return "\(v) \(h)"
        }
        else { return "invalid" }
    }
}
