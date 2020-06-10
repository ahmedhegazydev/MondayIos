//
//  NestedShowAllUsers.swift
//  ImageSlider
//
//  Created by A on 4/15/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit

class NestedShowAllUsers: UIView {

    @IBOutlet weak var tableViewUsers: UITableView!
    
    
    class func instanceFromNib() -> NestedShowAllUsers {
        return UINib(nibName: "NestedShowAllUsers", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! NestedShowAllUsers
    }
    
    
    

}
