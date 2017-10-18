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
    
    static let categoryImageDict : [Int:UIImage] = [0:UIImage(named: "iconChart")!,1:UIImage(named: "roll1")!,2:UIImage(named: "roll2")!];
    
    private init(){
        
    }
}
