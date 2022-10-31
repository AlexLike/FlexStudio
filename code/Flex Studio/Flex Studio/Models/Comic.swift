//
//  Comic.swift
//  Flex Studio
//
//  Created by Kai Zheng on 31.10.22.
//

import CoreData

class Comic: NSManagedObject {
    @NSManaged var order: Int16
    @NSManaged var name: String
    @NSManaged var date_created: Date
    @NSManaged var date_modified: Date
    
    @NSManaged var panels: Set<Panel>
}
