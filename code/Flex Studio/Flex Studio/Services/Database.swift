//
//  Database.swift
//  Flex Studio
//
//  Created by Alexander Zank on 28.10.22.
//

import Foundation

class Database: ObservableObject {
    private let coreDataStack = CoreDataStack()
    
    @Published var comics: [Comic] = []
    
    func fetchComics() async {
        let request = Comic.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "order", ascending: true)]
        
        await coreDataStack.context.perform {
            do {
                let comics = try self.coreDataStack.context.fetch(request)
                self.comics = comics as! [Comic]
            } catch {}
        }
    }
    
    func insertComic(name: String) async {
        let comic = Comic(context: coreDataStack.context)
        
        comic.order = Int16(comics.count) // Assuming insertComic is called always after we fetched all comics (and they are up to date!)
        comic.name = name
        comic.date_created = Date()
        comic.date_modified = Date()
        
        comic.panels = []
        
        coreDataStack.saveContext()
    }
    
    func insertPanel(for comic: Comic) {
        let panel = Panel(context: coreDataStack.context)
        
        panel.order = Int16(comic.panels.count)
        
        panel.parent_comic = comic
        comic.panels.insert(panel)
        
        coreDataStack.saveContext()
    }
    
    func insertLayer(for panel: Panel) {
        let layer = Layer(context: coreDataStack.context)
        
        layer.constraint_top = 0
        layer.constraint_leading = 0
        layer.constraint_trailing = 0
        layer.constraint_bottom = 0
        layer.position_x = 0
        layer.position_y = 0
        layer.position_z = Int16(panel.layers.count)
        
        layer.parent_panel = panel
        panel.layers.insert(layer)
        
        coreDataStack.saveContext()
    }
    
    func deleteComic(comic: Comic) {
        coreDataStack.context.delete(comic)
        coreDataStack.saveContext()
    }
    
    func deletePanel(panel: Panel) {
        panel.parent_comic.panels.remove(panel)
        
        coreDataStack.context.delete(panel)
        coreDataStack.saveContext()
    }
    
    func deleteLayer(layer: Layer) {
        layer.parent_panel.layers.remove(layer)
        
        coreDataStack.context.delete(layer)
        coreDataStack.saveContext()
    }
}
