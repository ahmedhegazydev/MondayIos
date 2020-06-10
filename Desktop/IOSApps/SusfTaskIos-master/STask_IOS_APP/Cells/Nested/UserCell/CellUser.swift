//
//  CellUser.swift
//  ImageSlider
//
//  Created by A on 4/15/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar

class CellUser: UITableViewCell {

    
    @IBOutlet weak var ivUserPhoto: UIImageView!
    
    @IBOutlet weak var lblUserName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
