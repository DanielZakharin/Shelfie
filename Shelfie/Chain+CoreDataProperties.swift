//
//  Chain+CoreDataProperties.swift
//  Shelfie
//
//  Created by iosdev on 5.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import CoreData


extension Chain {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chain> {
        return NSFetchRequest<Chain>(entityName: "Chain");
    }

    @NSManaged public var chainName: String?
    @NSManaged public var logoString: String?

}
