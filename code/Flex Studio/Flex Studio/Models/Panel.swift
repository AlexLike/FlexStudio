//
//  Panel.swift
//  Flex Studio
//
//  Created by Kai Zheng on 31.10.22.
//

import CoreData

class Panel: NSManagedObject {
    @NSManaged var order: Int16
    @NSManaged var name: String
    
    @NSManaged var parent_comic: Comic
    @NSManaged var layers: Set<Layer>
}
