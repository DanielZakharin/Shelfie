//
//  MetsaLabel.swift
//  Shelfie
//
//  Created by iosdev on 7.12.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class MetsaLabel: UILabel {

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
        self.font = UIFont(name: "BentonSans", size: self.font.pointSize);
    }
    
}
