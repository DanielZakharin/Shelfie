//
//  Store+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import CoreData


extension Store {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Store> {
        return NSFetchRequest<Store>(entityName: "Store");
    }

    @NSManaged public var storeName: String?
    @NSManaged public var storeAddress: String?
    @NSManaged public var contactNumber: String?
    @NSManaged public var contactPerson: String?
    @NSManaged public var shelfDepth: Int16
    @NSManaged public var shelfHeight: Int16
    @NSManaged public var shelfWidth: Int16
    @NSManaged public var chain: NSSet?

}

// MARK: Generated accessors for chain
extension Store {

    @objc(addChainObject:)
    @NSManaged public func addToChain(_ value: Chain)

    @objc(removeChainObject:)
    @NSManaged public func removeFromChain(_ value: Chain)

    @objc(addChain:)
    @NSManaged public func addToChain(_ values: NSSet)

    @objc(removeChain:)
    @NSManaged public func removeFromChain(_ values: NSSet)

}
