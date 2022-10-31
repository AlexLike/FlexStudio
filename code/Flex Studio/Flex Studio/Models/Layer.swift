//
//  Layer.swift
//  Flex Studio
//
//  Created by Kai Zheng on 31.10.22.
//

import CoreData

class Layer: NSManagedObject {
    @NSManaged var constraintTop: Float
    @NSManaged var constraintLeading: Float
    @NSManaged var constraintTrailing: Float
    @NSManaged var constraintBottom: Float
    @NSManaged var positionX: Float
    @NSManaged var positionY: Float
    @NSManaged var positionZ: Int16
    
    @NSManaged var parentPanel: Panel
}
