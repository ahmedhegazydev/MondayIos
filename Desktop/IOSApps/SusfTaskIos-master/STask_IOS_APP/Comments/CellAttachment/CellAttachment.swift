//
//  CellAttachment.swift
//  ImageSlider
//
//  Created by A on 4/7/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit

protocol ProtocolDownloadFile {
    func onDownloadFile(attach: Attachment?)
}

class CellAttachment: UITableViewCell {

    @IBOutlet weak var separator: UIProgressView!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var lblByName: UILabel!
    var attachment: Attachment?
    var delegate: ProtocolDownloadFile?
    @IBOutlet weak var labelFileName: UILabel!
    
    
    @IBOutlet weak var ivDownloadFile: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        self.ivDownloadFile.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(HandleTap)))
        self.ivDownloadFile.isUserInteractionEnabled = true
        
        
        
        
        //lblByName.font  = UIFont(name: "Poppins", size: 13)

        
        
    }
    
    @objc func HandleTap(){
        self.delegate?.onDownloadFile(attach: self.attachment)
        print("clicking")
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    
    func setAttachment(attachment: Attachment?){
        self.attachment = attachment
    }
}
