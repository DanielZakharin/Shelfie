//
//  MetsaStepper.swift
//  Shelfie
//
//  Created by iosdev on 8.12.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class MetsaStepper: UIStepper {

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
        //make a radius of 4, then mask to bounds to avoid backgroundcolor showing from under corners
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        self.backgroundColor = Tools.colors.metsaGreenPrimary;
        //color of the border / separator
        self.tintColor = Tools.colors.metsaLightGray
    }

}
