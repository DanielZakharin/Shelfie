//
//  MetsaButton.swift
//  Shelfie
//
//  Created by iosdev on 30.11.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit
/*
 Custom button class for a green, rounded corner button used throughout the app
 */

class MetsaButton: UIButton {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    override init(frame: CGRect){
        super.init(frame: frame)
        setup();
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup(){
        //setting the shape and color of the button
        //self.layer.borderWidth = 0.5
        self.backgroundColor = Tools.colors.metsaGreenPrimary;
        //self.layer.borderColor = UIColor(red: 143/255, green: 212/255, blue: 0, alpha: 1).cgColor;
        self.layer.cornerRadius = 20;
        //self.contentEdgeInsets = UIEdgeInsetsMake(5,5,5,5);
        self.titleEdgeInsets = UIEdgeInsetsMake(10,10,10,10)
        
        //setting the style of the text in the button
        self.setTitleColor(UIColor.white, for: .normal);
        self.setTitleShadowColor(UIColor.gray, for: .normal);
        self.titleLabel?.shadowOffset = CGSize(width: 1, height: 1);
        self.titleLabel?.minimumScaleFactor = 0.5;
        self.titleLabel?.numberOfLines = 1;
        self.titleLabel?.adjustsFontSizeToFitWidth = true;
        self.titleLabel?.font = UIFont(name: "BentonSans-Black", size: self.titleLabel!.font.pointSize);
    }
    
    override var intrinsicContentSize: CGSize {
        let labelSize = titleLabel?.sizeThatFits(CGSize(width: frame.width, height: .greatestFiniteMagnitude)) ?? .zero
        let desiredButtonSize = CGSize(width: labelSize.width + titleEdgeInsets.left + titleEdgeInsets.right, height: labelSize.height + titleEdgeInsets.top + titleEdgeInsets.bottom)
        
        return desiredButtonSize
    }
}
