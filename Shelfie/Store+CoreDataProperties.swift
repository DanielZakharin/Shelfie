//
//  Store+CoreDataProperties.swift
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

}
