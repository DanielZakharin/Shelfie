//
//  ProductBrand+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 23.11.2017.
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

extension ProductBrand {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductBrand> {
        return NSFetchRequest<ProductBrand>(entityName: "ProductBrand")
    }

    @NSManaged public var name: String?
    @NSManaged public var products: NSSet?
    @NSManaged public var manufacturer: Manufacturer?

}

// MARK: Generated accessors for products
extension ProductBrand {

    @objc(addProductsObject:)
    @NSManaged public func addToProducts(_ value: Product)

    @objc(removeProductsObject:)
    @NSManaged public func removeFromProducts(_ value: Product)

    @objc(addProducts:)
    @NSManaged public func addToProducts(_ values: NSSet)

    @objc(removeProducts:)
    @NSManaged public func removeFromProducts(_ values: NSSet)

}
