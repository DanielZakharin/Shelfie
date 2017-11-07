//
//  Store+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 30.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store");
    }

    @NSManaged public var contactNumber: String?
    @NSManaged public var contactPerson: String?
    @NSManaged public var shelfDepth: Int16
    @NSManaged public var shelfHeight: Int16
    @NSManaged public var shelfWidth: Int16
    @NSManaged public var storeAddress: String?
    @NSManaged public var storeName: String?
    @NSManaged public var storeChain: StoreChain?
    @NSManaged public var shelfPlans: NSSet?

}

// MARK: Generated accessors for shelfPlans
extension Store {

    @objc(addShelfPlansObject:)
    @NSManaged public func addToShelfPlans(_ value: ShelfPlan)

    @objc(removeShelfPlansObject:)
    @NSManaged public func removeFromShelfPlans(_ value: ShelfPlan)

    @objc(addShelfPlans:)
    @NSManaged public func addToShelfPlans(_ values: NSSet)

    @objc(removeShelfPlans:)
    @NSManaged public func removeFromShelfPlans(_ values: NSSet)

}
