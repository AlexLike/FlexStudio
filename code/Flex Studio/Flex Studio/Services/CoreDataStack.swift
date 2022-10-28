//
//  CoreDataStack.swift
//  Flex Studio
//
//  Created by Alexander Zank on 28.10.22.
//

import CoreData

class CoreDataStack {
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Flex_Studio")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error (error), (error.userInfo)")
            }
        })

        return container
    }()

    var context: NSManagedObjectContext { persistentContainer.viewContext }

    func saveContext () {
        if context.hasChanges {
            do {
                try context.save()
                print("CoreData: saved")
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error (nserror), (nserror.userInfo)")
            }
        }
    }
}
