//
//  Persistence.swift
//  SwiftCal
//
//  Created by Jack Cardinal on 3/9/23.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()
    
    let dataBaseName = "SwiftCal.sqlite"
    
    var oldStoreURL: URL {
        let directory = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return directory.appending(component: dataBaseName)
    }
    
    var sharedStoreURL: URL {
        let container = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.com.cardinal.SwiftCal")!
        return container.appending(component: dataBaseName)
    }

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        let startDate = Calendar.current.dateInterval(of: .month, for: .now)!.start
        for dateOffSet in 0..<30 {
            let newDay = Day(context: viewContext)
            newDay.date = Calendar.current.date(byAdding: .day, value: dateOffSet, to: startDate)
            newDay.didStudy = Bool.random()
        }
        do {
            try viewContext.save()
        } catch {

            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "SwiftCal")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
            
            //only run this if the oldStore !exists
        } else if !FileManager.default.fileExists(atPath: oldStoreURL.path) {
            print("🎅🏻 Old store doesn't exist. Using new shared URL")
           container.persistentStoreDescriptions.first!.url = sharedStoreURL
        }
        print("🕸️ Container URL = \(container.persistentStoreDescriptions.first!.url!)")
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
       migrateStore(for: container)
        
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
    
    func migrateStore(for container: NSPersistentContainer) {
        let coordinator = container.persistentStoreCoordinator
        print("🏃🏻‍♂️ running migrateStore")

        //this checks to see if the migration happened already and won't run it again
        guard let oldStore = coordinator.persistentStore(for: oldStoreURL) else { return }
        print("🛡️ Old store no longer exists")

        do {
           let _ = try coordinator.migratePersistentStore(oldStore, to: sharedStoreURL, type: .sqlite)
            //The _ = is because it returns a store, but we don't need it, without that, it will present warning
            print("🏁 Migration Successful")

        } catch {
            fatalError("Unable to migrate to shared store")
        }
        
        do {
            try FileManager.default.removeItem(at: oldStoreURL)
            print("🗑️ Old store deleted")

        } catch {
            print("Unable to remove old store")
        }
        
        
    }
}
