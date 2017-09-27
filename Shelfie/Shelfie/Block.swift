//
//  Block.swift
//  Shelfie
//
//  Created by iosdev on 14.9.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

class Block: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame);
        setupBlock();
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder);
        setupBlock();
    }
    
    func setupBlock(){
        print("block was added");
        self.backgroundColor = UIColor.blue;
    }
    
}
