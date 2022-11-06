//
//  Panel.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import CoreData

extension Panel {
    // MARK: - Data

    /// This panel's unique identifier, automatically generated on creation and persistent.
    var uid: UUID { uid_ ?? .init() }
    
    /// A timestamp of this panel's creation.
    var creationDate: Date? {
        get { creationDate_ }
        set { creationDate_ = newValue }
    }

    // MARK: - Relationships
    
    /// All layers this panel contains.
    var layers: Set<Layer> {
        get { layers_ as? Set<Layer> ?? [] }
        set { layers_ = newValue as NSSet }
    }
    
    /// All layers this panel consists of, sorted from furthest away to closest to the viewer.
    var sortedLayers: [Layer] { layers.sorted(using: KeyPathComparator(\.order)) }

    // MARK: - CRD operations

    @discardableResult
    static func create(in ctx: NSManagedObjectContext, creationDate: Date? = .now) -> Panel {
        let p = Panel(context: ctx)
        p.uid_ = UUID()
        p.creationDate_ = creationDate
        p.layers = []
        Layer.create(for: p, order: 0)
        return p
    }

    static func requestNewestToOldest() -> NSFetchRequest<Panel> {
        let request = Panel.fetchRequest()
        request
            .sortDescriptors = [NSSortDescriptor(keyPath: \Panel.creationDate_, ascending: false)]
        return request
    }

    func delete() {
        layers.forEach { $0.delete(removingFromPanel: false) }
        layers = []
        managedObjectContext!.delete(self)
    }
}
