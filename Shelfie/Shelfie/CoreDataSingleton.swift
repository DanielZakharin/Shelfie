//
//  CoreDataSingleton.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
import CoreData

class CoreDataSingleton {
    var persistentContainer : NSPersistentContainer?;
    var managedObjectContext = NSManagedObjectContext(concurrencyType: NSManagedObjectContextConcurrencyType.mainQueueConcurrencyType);
    
    
    static let sharedInstance = CoreDataSingleton();
    
    private init(){
        //make init private so that no other class can initialize it
        persistentContainer = NSPersistentContainer(name: "Shelfie");
        persistentContainer!.loadPersistentStores() { (description, error) in
            if let error = error {
                fatalError("Failed to load Core Data stack: \(error)")
            }
        }
        
        //This resource is the same name as your xcdatamodeld contained in your project
        guard let modelURL = Bundle.main.url(forResource: "Shelfie", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom);
        
        managedObjectContext.persistentStoreCoordinator = psc;
        
        let queue = DispatchQueue.global(qos: DispatchQoS.QoSClass.background)
        queue.async {
            guard let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else {
                fatalError("Unable to resolve document directory")
            }
            let storeURL = docURL.appendingPathComponent("Shelfie")
            do {
                try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
                //The callback block is expected to complete the User Interface and therefore should be presented back on the main queue so that the user interface does not need to be concerned with which queue this call is coming from.
            } catch {
                fatalError("Error migrating store: \(error)")
            }
        }
        //dummy fetch to activate coredata and avoid crashing
        fetchEntitiesFromCoreData("Chain");
    };
    
    //MARK: Adding entities to coredata
    func createStore(_ fromStoreWrapper: StoreWrapper) {
        let testStore = NSEntityDescription.insertNewObject(forEntityName: "Store", into: managedObjectContext) as! Store;
        testStore.storeName = fromStoreWrapper.storeName;
        testStore.storeAddress = fromStoreWrapper.storeAddress;
        testStore.contactPerson = fromStoreWrapper.contactPerson;
        testStore.contactNumber = fromStoreWrapper.contactNumber;
        saveContext();
    }
    
    func createStoreChain(_ withName: String){
        let newStoreChain = NSEntityDescription.insertNewObject(forEntityName: "StoreChain", into: managedObjectContext) as! StoreChain;
        newStoreChain.storeChainName = withName;
        saveContext();
    }
    
    func createChain(_ withName: String){
        let newChain = NSEntityDescription.insertNewObject(forEntityName: "Chain", into: managedObjectContext) as! Chain;
        newChain.chainName = withName;
        saveContext();
    }
    
    func fetchEntitiesFromCoreData(_ withEntityName: String) -> [NSManagedObject]{
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName);
        do {
            let fetchrResult = try managedObjectContext.fetch(fetchrequest) as! [NSManagedObject];
            return fetchrResult;
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    func saveContext(){
        do{
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
}
