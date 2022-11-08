//
//  PersistenceController.swift
//  Flex Studio
//
//  Created by Alexander Zank on 05.11.22.
//

import CoreData

/// A data structure that tracks this application's presence in Core Data.
struct PersistenceLayer {
    static let logger = Logger.forType(PersistenceLayer.self)

    static let shared = ExecutionEnvironment.isPreview ? preview : persistent
    static let persistent = PersistenceLayer(inMemory: false)
    static let preview: PersistenceLayer = {
        let result = PersistenceLayer(inMemory: true)
        let viewContext = result.container.viewContext
        // Populate with preview content here.
        for i in 0..<3 {
            Panel.create(
                in: result.container.viewContext,
                creationDate: .now.addingTimeInterval(TimeInterval(-i * 86400))
            )
        }
        do {
            try viewContext.save()
        } catch {
            // Replace this implementation with code to handle the error
            // appropriately.
            // fatalError() causes the application to generate a crash log and
            // terminate. You should not use this function in a shipping
            // application, although it may be useful during development.
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    private let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool) {
        // Register Transformers.
        DrawingTransformer.register()

        // Make Container.
        container = NSPersistentContainer(name: "Flex_Studio")
        if inMemory {
            container.persistentStoreDescriptions.first!
                .url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { _, error in
            if let error = error as NSError? {
                // TODO: - Improve corner case handling.
                Self.logger
                    .error(
                        "Failed to load the persistent stores. Reason: \(error.localizedDescription)"
                    )
                assertionFailure()
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    /// Flushes pending changes in viewContext to disk.
    @MainActor func save() {
        guard viewContext.hasChanges else { return }

        Self.logger.notice("Persisting to disk...")
        do { try viewContext.save() }
        catch {
            Self.logger.error("Failed to persist changes in viewContext to disk.")
            assertionFailure()
        }
        Self.logger.notice("Successfully finished persisting to disk.")
    }
}
