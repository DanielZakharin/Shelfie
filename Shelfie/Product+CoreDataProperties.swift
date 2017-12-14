//
//  Product+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 28.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//
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

extension Product {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Product> {
        return NSFetchRequest<Product>(entityName: "Product")
    }

    @NSManaged public var category: Int16
    @NSManaged public var depth: Int16
    @NSManaged public var height: Int16
    @NSManaged public var name: String?
    @NSManaged public var width: Int16
    @NSManaged public var barcode: String?
    @NSManaged public var brand: ProductBrand?

}
