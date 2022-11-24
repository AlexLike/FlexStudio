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
    static let debugBackupsKey = "DEBUGBACKUPSKEY"

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

    let container: NSPersistentContainer
    var viewContext: NSManagedObjectContext { container.viewContext }

    init(inMemory: Bool) {
        // Register Transformers.
        DrawingTransformer.register()
        ImageTransformer.register()

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

// MARK: - Debug

extension PersistenceLayer {
    static var storedBackupIdentifiers: [String] {
        guard
            let folder = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first,
            let contents = try? FileManager.default.contentsOfDirectory(
            at: folder,
            includingPropertiesForKeys: [.nameKey]
            )
        else { return [] }
        
        
        return contents.compactMap {
            let name = $0.deletingPathExtension().lastPathComponent
            return name.isEmpty ? nil : name
        }
    }
}

extension NSPersistentContainer {
    enum CopyPersistentStoreErrors: Error {
        case destinationError(String)
        case destinationNotRemoved(String)
        case copyStoreError(String)
    }

    @MainActor func copyPersistentStores(identifier: String) throws {
        DrawingTransformer.register()
        ImageTransformer.register()
        PersistenceLayer.shared.save()

        let backupURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!.appendingPathComponent(identifier + ".sqlite")

        if FileManager.default.fileExists(atPath: backupURL.path) {
            do {
                try FileManager.default.removeItem(at: backupURL)
            } catch {
                throw CopyPersistentStoreErrors
                    .destinationNotRemoved("Can't overwrite destination at \(backupURL)")
            }
        }

        do {
            try FileManager.default.createDirectory(
                at: backupURL,
                withIntermediateDirectories: true,
                attributes: nil
            )
        } catch {
            throw CopyPersistentStoreErrors
                .destinationError("Could not create destination directory at \(backupURL)")
        }

        for persistentStoreDescription in persistentStoreDescriptions {
            guard let storeURL = persistentStoreDescription.url else {
                continue
            }
            guard persistentStoreDescription.type != NSInMemoryStoreType else {
                continue
            }
            let temporaryPSC =
                NSPersistentStoreCoordinator(managedObjectModel: persistentStoreCoordinator
                    .managedObjectModel)
            let destinationStoreURL = backupURL.appendingPathComponent(storeURL.lastPathComponent)

            do {
                let newStore = try temporaryPSC.addPersistentStore(
                    ofType: persistentStoreDescription.type,
                    configurationName: persistentStoreDescription.configuration,
                    at: persistentStoreDescription.url,
                    options: persistentStoreDescription.options
                )
                let restoredTemporaryStore = try temporaryPSC.migratePersistentStore(
                    newStore,
                    to: destinationStoreURL,
                    options: persistentStoreDescription.options,
                    withType: persistentStoreDescription.type
                )
                print("Copied to temp store: \(restoredTemporaryStore)")
            } catch {
                throw CopyPersistentStoreErrors.copyStoreError("\(error.localizedDescription)")
            }
        }
    }

    @MainActor func restorePersistentStore(identifier: String) throws {
        DrawingTransformer.register()
        ImageTransformer.register()
        PersistenceLayer.shared.save()

        let backupURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
            .first!.appendingPathComponent(identifier + ".sqlite")

        for persistentStore in persistentStoreCoordinator.persistentStores {
            guard let loadedStoreURL = persistentStore.url else {
                continue
            }
            let backupStoreURL = backupURL.appendingPathComponent(loadedStoreURL.lastPathComponent)
            do {
                try persistentStoreCoordinator.remove(persistentStore)
            } catch {
                print("Error removing store: \(error)")
                throw CopyPersistentStoreErrors
                    .copyStoreError("Could not remove persistent store before restore")
            }
            do {
                try persistentStoreCoordinator.destroyPersistentStore(
                    at: loadedStoreURL,
                    ofType: persistentStore.type,
                    options: persistentStore.options
                )
                let backupStore = try persistentStoreCoordinator.addPersistentStore(
                    ofType: persistentStore.type,
                    configurationName: persistentStore.configurationName,
                    at: backupStoreURL,
                    options: persistentStore.options
                )
                let restoredTemporaryStore = try persistentStoreCoordinator.migratePersistentStore(
                    backupStore,
                    to: loadedStoreURL,
                    options: persistentStore.options,
                    withType: persistentStore.type
                )
                print("Restored temp store: \(restoredTemporaryStore)")
            } catch {
                throw CopyPersistentStoreErrors
                    .copyStoreError("Could not restore: \(error.localizedDescription)")
            }
        }
    }
}
