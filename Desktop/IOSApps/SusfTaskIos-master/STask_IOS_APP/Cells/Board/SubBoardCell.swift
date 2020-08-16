//
//  SubBoardCell.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 8/15/20.
//  Copyright © 2020 Susfweb. All rights reserved.
//

import Foundation
import UIKit


final class SubBoardCell: UITableViewCell {
    
    let label = UILabel()

//    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var lblTitle: UILabel!
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        //contentView.addSubview(label)
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
       super.init(coder: aDecoder)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
//        label.frame = contentView.bounds
//        label.frame.origin.x += 12
    }
    
    override func awakeFromNib() {
    super.awakeFromNib()
        
    }
}
