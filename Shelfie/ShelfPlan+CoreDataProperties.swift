//
//  ShelfPlan+CoreDataProperties.swift
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

extension ShelfPlan {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ShelfPlan> {
        return NSFetchRequest<ShelfPlan>(entityName: "ShelfPlan");
    }

    @NSManaged public var date: NSDate?
    @NSManaged public var verticalSize: Int16
    @NSManaged public var store: Store?
    @NSManaged public var boxes: NSSet?

}

// MARK: Generated accessors for boxes
extension ShelfPlan {

    @objc(addBoxesObject:)
    @NSManaged public func addToBoxes(_ value: ShelfBox)

    @objc(removeBoxesObject:)
    @NSManaged public func removeFromBoxes(_ value: ShelfBox)

    @objc(addBoxes:)
    @NSManaged public func addToBoxes(_ values: NSSet)

    @objc(removeBoxes:)
    @NSManaged public func removeFromBoxes(_ values: NSSet)

}
