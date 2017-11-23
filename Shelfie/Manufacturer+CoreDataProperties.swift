//
//  Manufacturer+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 23.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//
//

import Foundation
import CoreData


extension Manufacturer {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Manufacturer> {
        return NSFetchRequest<Manufacturer>(entityName: "Manufacturer")
    }

    @NSManaged public var name: String?
    @NSManaged public var brands: NSSet?

}

// MARK: Generated accessors for brands
extension Manufacturer {

    @objc(addBrandsObject:)
    @NSManaged public func addToBrands(_ value: ProductBrand)

    @objc(removeBrandsObject:)
    @NSManaged public func removeFromBrands(_ value: ProductBrand)

    @objc(addBrands:)
    @NSManaged public func addToBrands(_ values: NSSet)

    @objc(removeBrands:)
    @NSManaged public func removeFromBrands(_ values: NSSet)

}
