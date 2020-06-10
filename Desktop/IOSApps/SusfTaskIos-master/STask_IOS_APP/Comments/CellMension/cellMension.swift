//
//  cellMension.swift
//  ImageSlider
//
//  Created by A on 4/8/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit

import SwiftyAvatar

class cellMension: UITableViewCell {

    
    
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var ivUserPhoto: SwiftyAvatar!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        
        
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
