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
        testStore.storeChain = fromStoreWrapper.storeChain;
        testStore.shelfWidth = Int16(fromStoreWrapper.shelfWidth!);
        saveContext();
    }
    
    func createProduct(_ fromProductWrapper: ProductWrapper){
        let newProduct = NSEntityDescription.insertNewObject(forEntityName: "Product", into: managedObjectContext) as! Product;
        newProduct.name = fromProductWrapper.name;
        newProduct.category = Int16(fromProductWrapper.category!);
        newProduct.brand = fromProductWrapper.brand;
        newProduct.depth = Int16(fromProductWrapper.depth!);
        newProduct.height = Int16(fromProductWrapper.height!);
        newProduct.width = Int16(fromProductWrapper.width!);
        saveContext();
    }
    
    func createStoreChain(_ withName: String, inChain: Chain?){
        let newStoreChain = NSEntityDescription.insertNewObject(forEntityName: "StoreChain", into: managedObjectContext) as! StoreChain;
        newStoreChain.storeChainName = withName;
        newStoreChain.chain = inChain;
        inChain?.addToStoreChains(newStoreChain);
        saveContext();
    }
    
    func createChain(_ withName: String, completion: (() -> Void)?){
        let newChain = NSEntityDescription.insertNewObject(forEntityName: "Chain", into: managedObjectContext) as! Chain;
        newChain.chainName = withName;
        saveContext();
        completion?();
    }
    
    func createManufacturer(_ withName: String, completion: (()->Void)?){
        let newMan = NSEntityDescription.insertNewObject(forEntityName: "Manufacturer", into: managedObjectContext) as! Manufacturer;
        newMan.name = withName;
        saveContext();
        completion?();
    }
    
    func createBrand(_ withName: String, withManufacturer: Manufacturer ,completion: (() -> Void)?){
        let newBrand = NSEntityDescription.insertNewObject(forEntityName: "ProductBrand", into: managedObjectContext) as! ProductBrand;
        newBrand.name = withName;
        newBrand.manufacturer = withManufacturer;
        saveContext();
        completion?();
    }
    
    func createShelfBox(_ fromShelfBoxWrapper: BoxWrapper) -> ShelfBox{
        let newBox = NSEntityDescription.insertNewObject(forEntityName: "ShelfBox", into: managedObjectContext) as! ShelfBox;
        newBox.coordX = Int16(fromShelfBoxWrapper.size.origin.x);
        newBox.coordY = Int16(fromShelfBoxWrapper.size.origin.y);
        newBox.height = Int16(fromShelfBoxWrapper.size.height);
        newBox.width = Int16(fromShelfBoxWrapper.size.width);
        newBox.product = fromShelfBoxWrapper.product;
        //saveContext();
        return newBox;
    }
    
    func createShelfBoxes(_ fromBoxWrapperArray: [BoxWrapper]) -> [ShelfBox]{
        var shelfBoxes: [ShelfBox] = [];
        for boxWrpr in fromBoxWrapperArray{
            shelfBoxes.append(createShelfBox(boxWrpr));
        }
        return shelfBoxes;
    }
    
    func createShelfPlan(_ fromShelfWrapper: ShelfWrapper){
        print(1);
        let newShelf = NSEntityDescription.insertNewObject(forEntityName: "ShelfPlan", into: managedObjectContext) as! ShelfPlan;
        print(2);
        newShelf.boxes = NSSet(array: createShelfBoxes(fromShelfWrapper.boxes));
        print(3);
        newShelf.date = fromShelfWrapper.date as NSDate?;
        print(4);
        newShelf.store = fromShelfWrapper.store;
        print(5);
        newShelf.verticalSize = fromShelfWrapper.shelfHeight;
        print(6);
        print("Created a shelfplan!");
        saveContext();
    }
    
    func fetchEntitiesFromCoreData(_ withEntityName: String, withSearchTerm: String? = nil, forVariable: String? = nil) -> [NSManagedObject]{
        let fetchrequest = NSFetchRequest<NSFetchRequestResult>(entityName: withEntityName);
        if((withSearchTerm != nil) && (forVariable != nil)){
            fetchrequest.predicate = NSPredicate(format: "\(forVariable!) contains [c] %@", withSearchTerm!);
        }
        do {
            let fetchrResult = try managedObjectContext.fetch(fetchrequest) as! [NSManagedObject];
            return fetchrResult;
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    private func saveContext(){
        print(999);
        do{
            try managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }
    
    func fetchWithMultipleConditions(_ entityName: String , searchterms: [String:String]) -> [NSManagedObject]{
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName);
        var subPredicates : [NSPredicate] = [];
        for (key,value) in searchterms {
            let subPredicate = NSPredicate(format: "%K == %@", key, value);
            subPredicates.append(subPredicate);
        }
        fetchRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: subPredicates);
        do {
            let fetchrResult = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject];
            return fetchrResult;
        } catch {
            fatalError("Failed to fetch employees: \(error)")
        }
    }
    
    
    //MARK: DANGER ZONE
    func deleteAllData(entity: String)
    {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        fetchRequest.returnsObjectsAsFaults = false
        
        do
        {
            let results = try managedObjectContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedObjectContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
    }
}
