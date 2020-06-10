//
//  CellMail2.swift
//  ImageSlider
//
//  Created by A on 4/17/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar


protocol ProtocolInboxSection{
    func onReplyClicked(mail: InboxGetUser?)
    func onLblMakeInboxAsSeenClicked(mail: InboxGetUser?, users: String)
}

class CellMail2: UITableViewCell {
    
    
    @IBOutlet weak var ivReply: UIImageView!
    @IBOutlet weak var ivIsSeen: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    var delegate: ProtocolInboxSection?
    var mail: InboxGetUser?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivShowAttachments: SwiftyAvatar!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivUserImage: UIImageView!
    
    @IBOutlet weak var stackBottomSec: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        
        self.ivReply.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReply)))
        self.ivReply.isUserInteractionEnabled = true;
        
        self.lblComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowMailSubject)))
        self.lblComment.isUserInteractionEnabled = true;
        
        self.lblUserName.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowMailSubject)))
        self.lblUserName.isUserInteractionEnabled = true;
        
        
        
    }
    
    @objc func handleReply(){
        //print("clicked")
        delegate?.onReplyClicked(mail: self.mail)
        
    }
   
    @objc func handleShowMailSubject(){
           //print("clicked")
        delegate?.onLblMakeInboxAsSeenClicked(mail: self.mail, users: self.lblUserName.text!)
           
       }
    
    func setMail(mail: InboxGetUser?){
        self.mail = mail
    }
    
    
    
    
    
}
