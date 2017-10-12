//
//  Chain+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 12.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import CoreData

/*
 #######################################################
 #               FOR FUTURE KNOWLEDGE                  #
 #    to get correct coredata classes, set module to   #
 #      current project and codegen to manual/none     #
 #######################################################
 */

extension Chain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chain> {
        return NSFetchRequest<Chain>(entityName: "Chain");
    }

    @NSManaged public var chainName: String?
    @NSManaged public var logoString: String?
    @NSManaged public var storeChains: NSSet?

}

// MARK: Generated accessors for storeChains
extension Chain {

    @objc(addStoreChainsObject:)
    @NSManaged public func addToStoreChains(_ value: StoreChain)

    @objc(removeStoreChainsObject:)
    @NSManaged public func removeFromStoreChains(_ value: StoreChain)

    @objc(addStoreChains:)
    @NSManaged public func addToStoreChains(_ values: NSSet)

    @objc(removeStoreChains:)
    @NSManaged public func removeFromStoreChains(_ values: NSSet)

}
