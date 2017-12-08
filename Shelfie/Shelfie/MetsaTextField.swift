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
        let font: UIFont = UIFont(name: "BentonSans-Black", size: 18)!;
        self.layer.cornerRadius = 4;
        self.layer.masksToBounds = true;
        self.backgroundColor = Tools.colors.metsaLighterGray;
        self.tintColor = Tools.colors.metsaGreenPrimary
        self.font = font;
        
    }
    
}
