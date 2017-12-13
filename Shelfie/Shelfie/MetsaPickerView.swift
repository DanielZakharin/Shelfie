//
//  MetsaPickerView.swift
//  Shelfie
//
//  Created by iosdev on 8.12.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class MetsaPickerView: UIPickerView {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    /*
    currently the class is useless, as setting the style for labels in the picker is done from
    viewforrow method of the delegage
     
     any future styling can be added here, as long as it works outside viewforrow
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
        self.tintColor = Tools.colors.metsaGreenPrimary
    }
    
}
