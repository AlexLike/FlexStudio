//
//  Layer.swift
//  Flex Studio
//
//  Created by Kai Zheng on 31.10.22.
//

import CoreData

class Layer: NSManagedObject {
    @NSManaged var order: Int16
    @NSManaged var constraint_top: Float
    @NSManaged var constraint_leading: Float
    @NSManaged var constraint_trailing: Float
    @NSManaged var constraint_bottom: Float
    @NSManaged var position_x: Float
    @NSManaged var position_y: Float
    
    @NSManaged var parent_panel: Panel
}
