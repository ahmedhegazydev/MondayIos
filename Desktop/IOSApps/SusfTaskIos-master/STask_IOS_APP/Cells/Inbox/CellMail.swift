//
//  CellMail.swift
//  ImageSlider
//
//  Created by A on 4/11/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar



class CellMail: UITableViewCell {

    
    @IBOutlet weak var ivUserImage: SwiftyAvatar!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblSubject: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
}
