//
//  Panel.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import CoreData
import SwiftUI

extension Panel {
    // MARK: - Data
    
    /// This panel's unique identifier, automatically generated on creation and persistent.
    var uid: UUID { uid_ ?? .init() }
    
    /// A timestamp of this panel's creation.
    var creationDate: Date? {
        get { creationDate_ }
        set { creationDate_ = newValue }
    }
    
    var size: CGSize {
        get { .init(width: CGFloat(width_), height: CGFloat(height_)) }
        set {
            width_ = Float(newValue.width)
            height_ = Float(newValue.height)
        }
    }
    
    var previewImage: UIImage? {
        get {
            if let imageData = previewImage_ {
                return UIImage(data: imageData)
            }
            return nil
        }
        set {
            previewImage_ = newValue?.pngData()
        }
    }

    // MARK: - Relationships
    
    /// All layers this panel contains.
    var layers: Set<Layer> {
        get { layers_ as? Set<Layer> ?? [] }
        set { layers_ = newValue as NSSet }
    }
    
    /// All layers this panel consists of, sorted from furthest away to closest to the viewer.
    var sortedLayers: [Layer] { layers.sorted(using: KeyPathComparator(\.order)) }
    
    // MARK: - Global
    
    static let defaultSize: CGSize = .init(width: 1000, height: 700)
    static let minSize: CGSize = .init(width: 200, height: 200)

    // MARK: - CRD operations
    
    @discardableResult
    static func create(in ctx: NSManagedObjectContext, creationDate: Date? = .now) -> Panel {
        let p = Panel(context: ctx)
        p.uid_ = UUID()
        p.creationDate_ = creationDate
        p.width_ = Float(defaultSize.width)
        p.height_ = Float(defaultSize.height)
        p.layers = []
        Layer.create(for: p, order: 0)
        return p
    }
    
    func addLayer() {
        Layer.create(for: self, order: Int16(self.layers.count))
    }
    
    func deleteLayer(layer : Layer) {
        // TODO: delete layer entirely
        let deletedOrder = Int(layer.order)
        self.layers.remove(layer)
        //layer.delete()
        for i in deletedOrder ..< layers.count {
            self.sortedLayers[i].order -= 1
        }
    }

    static let fetchRequestOldestToNewest: NSFetchRequest<Panel> = {
        let request = Panel.fetchRequest()
        request
            .sortDescriptors = [NSSortDescriptor(keyPath: \Panel.creationDate_, ascending: true)]
        return request
    }()

    func delete() {
        layers.forEach { $0.delete(removingFromPanel: false) }
        layers = []
        managedObjectContext!.delete(self)
    }
}
