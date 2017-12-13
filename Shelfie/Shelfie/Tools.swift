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
    
    struct Colors {
        let metsaGreenPrimary = UIColor(red: 143/255, green: 212/255, blue: 0, alpha: 1);
        let metsaGreenSecondary = UIColor(red: 123/255, green: 192/255, blue: 0, alpha: 1);
        let metsaDarkGray = UIColor(red: 54/255, green: 53/255, blue: 51/255, alpha: 1);
        let metsaLightGray = UIColor(red: 142/255, green: 144/255, blue: 143/255, alpha: 1);
        let metsaLighterGray = UIColor(red: 200/255, green: 202/255, blue: 201/255, alpha: 1);
    }
        
    static let colors = Colors();
    
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
    
    static func formattedPickerLabel(_ view: UIView?, withTitle: String) -> UILabel{
        var pickerLabel = view as! UILabel!
        if view == nil {  //if no label there yet
            pickerLabel = UILabel()
            pickerLabel?.textColor = Tools.colors.metsaDarkGray;
            pickerLabel?.textAlignment = .center;
            pickerLabel?.font = UIFont(name: "BentonSans", size: 18)
        }
        pickerLabel?.text = withTitle;
        return pickerLabel!;
    }
    
    static func formatTextField(_ textField: UITextField) {
        let font: UIFont = UIFont(name: "BentonSans", size: 18)!;
        textField.layer.cornerRadius = 4;
        textField.layer.masksToBounds = true;
        textField.tintColor = Tools.colors.metsaGreenPrimary
        textField.font = font;
    }
    
    static func roundToNearest(x : CGFloat) -> CGFloat {
        let jee = increment * CGFloat(round(x / increment));
        //print("Rounded \(x) to \(jee)");
        return jee;
    }
    
    static func intToIncrement(int: Int16) -> CGFloat {
        return CGFloat(int)*increment;
    }
    
    static func generateRandomColor() -> UIColor {
        let hue : CGFloat = CGFloat(arc4random() % 256) / 256 // use 256 to get full range from 0.0 to 1.0
        let saturation : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from white
        let brightness : CGFloat = CGFloat(arc4random() % 128) / 256 + 0.5 // from 0.5 to 1.0 to stay away from black
        
        return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1)
    }
    
    static let categoryImageDict : [Int16:UIImage] = [0:UIImage(named: "tissue")!,1:UIImage(named: "vessa")!,2:UIImage(named: "talous")!];
    static let categoryNameDict : [Int: String] = [0:"Tissue", 1:"WC-Paper",2:"Kitchen Paper"];
    static let categoryColorDict : [Int: UIColor] = [
        0:colors.metsaGreenPrimary,
        1:UIColor(red: 255/255, green: 161/255, blue: 53/255, alpha: 1),
        2:UIColor(red: 51/255, green: 102/255, blue: 204/255, alpha: 1)
    ];
    
    
    private init(){
        
        
    }
    
}
