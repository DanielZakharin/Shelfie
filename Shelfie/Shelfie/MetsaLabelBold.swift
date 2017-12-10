//
//  MetsaLabelBold.swift
//  Shelfie
//
//  Created by iosdev on 7.12.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class MetsaLabelBold: MetsaLabel {

    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */
    
    override func setup(){
        self.font = UIFont(name: "BentonSans-Black", size: self.font.pointSize);
    }

}
