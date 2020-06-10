//
//  NestedShowAllUsers.swift
//  ImageSlider
//
//  Created by A on 4/15/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit

class MentionBodyView: UIView {

    @IBOutlet weak var tableViewMentions: UITableView!
    
    
    class func instanceFromNib() -> MentionBodyView {
        return UINib(nibName: "MentionsBody", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! MentionBodyView
        
    }
    
    
    

}
