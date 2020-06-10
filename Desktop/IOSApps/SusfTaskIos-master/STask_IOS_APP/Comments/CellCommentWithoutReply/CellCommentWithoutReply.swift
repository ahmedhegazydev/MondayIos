//
//  CellCommentWithputReply.swift
//  ImageSlider
//
//  Created by A on 4/9/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar


class CellCommentWithoutReply: UITableViewCell {

    @IBOutlet weak var ivUserPhoto: SwiftyAvatar!
    //@IBOutlet weak var ivAttach: UIImageView!
    @IBOutlet weak var labelUserName: UILabel!
    @IBOutlet weak var labelCommentTop: UILabel!
    @IBOutlet weak var labelCommentBottom: UILabel!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    required init?(coder: NSCoder) {
           super.init(coder: coder)
           
           //assertionFailure(<#T##message: String##String#>)
       }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
