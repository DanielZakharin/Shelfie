//
//  ShelfBox+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 30.10.2017.
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

extension ShelfBox {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShelfBox> {
        return NSFetchRequest<ShelfBox>(entityName: "ShelfBox");
    }

    @NSManaged public var coordX: Int16
    @NSManaged public var coordY: Int16
    @NSManaged public var width: Int16
    @NSManaged public var height: Int16
    @NSManaged public var product: Product?

}
