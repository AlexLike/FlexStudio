//
//  KeyframeAssistant.swift
//  Flex Studio
//
//  Created by Alexander Zank on 21.11.22.
//

import Foundation

protocol KeyframeAssistant: ObservableObject {
    var isEditingResponsivity: Bool { get }

    var aspectProgression: CGFloat { get set }
    var sortedKeyframeProgressions: [CGFloat] { get }
    
    var currentKeyframe: Keyframe? { get }
    var currentOffset: CGSize { get }
    func modifyCurrentKeyframePosition(to target: CGSize)

    func toggleKeyframe()
}
