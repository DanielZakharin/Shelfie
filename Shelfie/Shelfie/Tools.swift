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
    
    static let increment : CGFloat = UIScreen.main.bounds.width/30;
    
    static func checkTextFieldValid(textField: UITextField, _ viewControllerForAlert: UIViewController? = nil) -> Bool{
        if((textField.text) != nil && !textField.text!.isEmpty){
            return true;
        }
        textField.layer.borderWidth = 2;
        textField.layer.borderColor = UIColor.red.cgColor;
        if(viewControllerForAlert != nil){
            viewControllerForAlert?.alert(message: "Some fields are empty, or invalid.")
        }
        return false;
    }
    
    static func roundToNearest(x : CGFloat) -> CGFloat {
        let jee = increment * CGFloat(round(x / increment));
        //print("Rounded \(x) to \(jee)");
        return jee;
    }
    
    static func intToIncrement(int: Int16) -> CGFloat {
        return CGFloat(int)*increment;
    }
    
    static let categoryImageDict : [Int:UIImage] = [0:UIImage(named: "iconChart")!,1:UIImage(named: "roll1")!,2:UIImage(named: "roll2")!];
    static let categoryNameDict : [Int: String] = [0:"Tissue", 1:"WC-Paper",2:"Kitchen Paper"];
    static let categoryColorDict : [Int: UIColor] = [0:UIColor.yellow,1:UIColor.green,2:UIColor.brown];
    private init(){
        
    }
    
}
