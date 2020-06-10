//
//  MyTableViewCell.swift
//  LUExpandableTableViewExample
//
//  Created by Laurentiu Ungur on 24/11/2016.
//  Copyright © 2016 Laurentiu Ungur. All rights reserved.
//

import UIKit

final class BoardCell: UITableViewCell {
    
    let label = UILabel()

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
