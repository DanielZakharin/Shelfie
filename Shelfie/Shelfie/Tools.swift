//
//  Tools.swift
//  Shelfie
//
//  Created by iosdev on 18.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import Foundation
import UIKit
class Tools{
    
    let sharedInstance = Tools();
    
    static func checkTextFieldValid(textField: UITextField) -> Bool{
        if((textField.text) != nil && !textField.text!.isEmpty){
            return true;
        }
        return false;
    }
    
    private init(){
        
    }
}
