//
//  NotificationTableViewCell.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import TextImageButton
import SwiftyAvatar

class NotificationTableViewCell: UITableViewCell {


  
    @IBOutlet weak var ivWithoutborder: UIImageView!
    @IBOutlet weak var viewColor: UIView!
    @IBOutlet weak var lblNotifiData: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivUserImage: SwiftyAvatar!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
      //lblUserName.font = UIFont(name:"Droid Arabic Kufi",size:12)

        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
