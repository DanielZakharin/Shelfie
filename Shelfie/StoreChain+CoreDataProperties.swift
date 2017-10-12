//
//  StoreChain+CoreDataProperties.swift
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

extension StoreChain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<StoreChain> {
        return NSFetchRequest<StoreChain>(entityName: "StoreChain");
    }

    @NSManaged public var storeChainName: String?
    @NSManaged public var logoString: String?
    @NSManaged public var stores: Store?
    @NSManaged public var chain: Chain?

}
