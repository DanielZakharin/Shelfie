//
//  File.swift
//  Shelfie
//
//  Created by iosdev on 30.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import CoreData

class ShelfWrapper {
    var date: Date = Date();
    var shelfHeight: Int16 = 1;
    var boxes: [BoxWrapper] = [];
    var store: Store;
    
    init(stoure: Store) {
        store = stoure;
    }
}
