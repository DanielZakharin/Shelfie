//
//  ProductBrand+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 30.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import CoreData


extension ProductBrand {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProductBrand> {
        return NSFetchRequest<ProductBrand>(entityName: "ProductBrand");
    }

    @NSManaged public var name: String?
    @NSManaged public var products: Product?

}
