//
//  MetsaSegmentedControl.swift
//  Shelfie
//
//  Created by iosdev on 8.12.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class MetsaSegmentedControl: UISegmentedControl {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setup();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setup();
    }
    
    func setup(){
        let font: UIFont = UIFont(name: "BentonSans-Black", size: 18)!;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        self.backgroundColor = Tools.colors.metsaLightGray;
        self.tintColor = Tools.colors.metsaGreenPrimary
        //self.layer.cornerRadius = 20;
        self.setTitleTextAttributes(
            [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: font
            ], for: .normal)
        self.setTitleTextAttributes(
            [
            NSAttributedStringKey.foregroundColor: UIColor.white,
            NSAttributedStringKey.font: font
            ], for: .selected)
        
    }

}
