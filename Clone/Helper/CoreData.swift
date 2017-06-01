//
//  CoreData.swift
//  Clone
//
//  Created by FARHAN IT SOLUTION on 31/05/17.
//
//

import UIKit
import CoreData

class CoreDataStore : NSObject{
    
    let storeName = "CoreDataStore"
    
    lazy var storeFileName: String = {
        return  "\(self.storeName).sqlite"
    }()
    
    lazy var applicationDocumentsDirectory: URL = {
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return urls[urls.count - 1]
        
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        // The managed object model for the application. This property is not optional. It is a fatal error for the application not to be able to find and load its model.
        
        let modelUrl = Bundle.main.url(forResource: self.storeName, withExtension: "momd")!
        
        return NSManagedObjectModel(contentsOf: modelUrl)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        // The persistent store coordinator for the application. This implementation creates and returns a coordinator, having added the store for the application to it. This property is optional since there are legitimate error conditions that could cause the creation of the store to fail.
        
        // Create the coordinator store
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.storeFileName)
        print("Database url : \(url)")
        
        var failureReason = "There was an error creating or loading the application's saved data."
        
        do{
            
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: [
                NSMigratePersistentStoresAutomaticallyOption : true,
                NSInferMappingModelAutomaticallyOption : true,
                ])
            
        }catch{
            
            // Report any error we got.
            var dict = [String: AnyObject]()
            dict[NSLocalizedDescriptionKey] = "Failed to initialize the application's saved data" as AnyObject?
            dict[NSLocalizedFailureReasonErrorKey] = failureReason as AnyObject?
            
            dict[NSUnderlyingErrorKey] = error as NSError
            let wrappedError = NSError(domain: "YOUR_ERROR_DOMAIN", code: 9999, userInfo: dict)
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog("Unresolved error \(wrappedError), \(wrappedError.userInfo)")
            abort()
            
        }
        
        return coordinator
    }()
    
}

class CoreDataManager: NSObject {
    
    /// Shared Instance
    static let `default` = CoreDataManager()
    
    let store: CoreDataStore = CoreDataStore()
    
    private override init() {
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(contextDidSaveContext(notification:)), name: NSNotification.Name.NSManagedObjectContextDidSave, object: managedObjectContext)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    lazy var managedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.store.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    lazy var backgroundManagedObjectContext: NSManagedObjectContext = {
        // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.) This property is optional since there are legitimate error conditions that could cause the creation of the context to fail.
        
        var managedObjectContext = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        managedObjectContext.persistentStoreCoordinator = self.store.persistentStoreCoordinator
        
        return managedObjectContext
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext(context: NSManagedObjectContext)  {
        
        if context.hasChanges {
            
            do{
                try context.save()
            }catch{
                // Replace this implementation with code to handle the error appropriately.
                // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                NSLog("Unresolved error \(nserror), \(nserror.userInfo)")
                abort()
            }
            
        }
        
    }
    
    func saveContext () {
        self.saveContext(context: self.backgroundManagedObjectContext)
    }
    
    // MARK: - Notification
    
    // call back function by saveContext, support multi-thread
    func contextDidSaveContext(notification: Notification) {
        
        let sender = notification.object as! NSManagedObjectContext
        
        if sender === self.managedObjectContext {
            NSLog("******** Saved main Context in this thread")
            
            self.backgroundManagedObjectContext.perform({
                self.backgroundManagedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
            })
            
        }else if sender === self.backgroundManagedObjectContext{
            NSLog("******** Saved background Context in this thread")
            
            self.managedObjectContext.perform({
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            })
            
        }else{
            NSLog("******** Saved Context in other thread")
            
            self.backgroundManagedObjectContext.perform({
                self.backgroundManagedObjectContext.mergeChanges(fromContextDidSave: notification as Notification)
            })
            
            self.managedObjectContext.perform({
                self.managedObjectContext.mergeChanges(fromContextDidSave: notification)
            })
            
        }
        
    }
    
}


class CoreDataHelper: NSObject {
    
    static func insertNewObject(forEntityName entityName: String) -> NSManagedObject{
        
        let coreDataManager = CoreDataManager.default
        
        let managedObject = NSEntityDescription.insertNewObject(forEntityName: entityName, into: coreDataManager.managedObjectContext)
        
        //        let managedObject = NSManagedObject(entity: entity, insertInto: coreDataManager.managedObjectContext)
        
        return managedObject
        
    }
    
    static func fetchRequest(forEntity entityName: String) -> NSFetchRequest<NSFetchRequestResult>  {
        
        let fetchRequest: NSFetchRequest<NSFetchRequestResult> = NSFetchRequest(entityName: entityName)
        
        return fetchRequest
        
    }
    
    static func fetchAll(request: NSFetchRequest<NSFetchRequestResult> ) -> [NSManagedObject] {
        
        var records: [NSManagedObject] = []
        
        let coreDataManager = CoreDataManager.default
        
        do {
            
            let results = try coreDataManager.managedObjectContext.fetch(request) as! [NSManagedObject]
            
            records += results
            
        } catch let error {
            print("Error while executing \(#function) :",error)
        }
        
        return records
    }
    
    static func fetchOne(request: NSFetchRequest<NSFetchRequestResult> ) -> NSManagedObject? {
        
        let records = self.fetchAll(request: request)
        
        var managedObject: NSManagedObject?
        
        if records.count > 0 {
            managedObject = records[0]
        }
        
        return managedObject
    }
    
    static func delete(managedObject: NSManagedObject)-> Bool{
        
        let coreDataManager = CoreDataManager.default
        
        coreDataManager.managedObjectContext.delete(managedObject)
        
        return self.saveManagedObjectContext()
    }
    
    static func saveManagedObjectContext() -> Bool{
        
        let coreDataManager = CoreDataManager.default
        
        do {
            try coreDataManager.managedObjectContext.save()
            return true
        } catch{
            return false
        }
        
    }
    
}
