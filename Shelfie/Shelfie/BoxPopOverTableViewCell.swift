//
//  BoxPopOverTableViewCell.swift
//  Shelfie
//
//  Created by iosdev on 4.10.2017.
//  Copyright © 2017 Group-6. All rights reserved.
//

import UIKit

/*
 Cell for boxpopovertableview
 */

class BoxPopOverTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: MetsaLabel!
    @IBOutlet weak var subtitleLabel: MetsaLabel!
    @IBOutlet weak var categoryImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
