//
//  MetsaTextField.swift
//  Shelfie
//
//  Created by iosdev on 8.12.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class MetsaTextField: UITextField {

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
        let font: UIFont = UIFont(name: "BentonSans", size: 18)!;
        //make a radius of 4, then mask to bounds to avoid backgroundcolor showing from under corners
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        self.backgroundColor = UIColor.white;//Tools.colors.metsaLighterGray;
        self.tintColor = Tools.colors.metsaGreenPrimary
        self.font = font;
    }
    
}
