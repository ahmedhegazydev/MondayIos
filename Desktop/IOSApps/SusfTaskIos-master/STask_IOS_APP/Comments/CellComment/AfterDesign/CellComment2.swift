//
//  CellComment2.swift
//  ImageSlider
//
//  Created by A on 4/15/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar

@available(iOS 13.0, *)
class CellComment2: UITableViewCell {
    
    
    @IBOutlet weak var ivReply: UIImageView!
    @IBOutlet weak var ivIsSeen: UIImageView!
    @IBOutlet weak var lblComment: UILabel!
    var delegateCommentOptions: ProtocolCommentOptions?
    var comment: Comment?
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivShowAttachments: SwiftyAvatar!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var ivUserImage: SwiftyAvatar!
    
    @IBOutlet weak var stackBottomSec: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        
        //        stackBottomSec.addBackground(color: Utils.hexStringToUIColor(hex: "#FAFAFA"))
        
        
        self.selectionStyle = UITableViewCell.SelectionStyle.none
        
        self.ivShowAttachments.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAttach)))
        self.ivShowAttachments.isUserInteractionEnabled = true;
        
        
        self.ivReply.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleReply)))
        self.ivReply.isUserInteractionEnabled = true;
        
        
        self.lblComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowAllComment)))
               self.lblComment.isUserInteractionEnabled = true;
        
    }
    
    
    @objc func handleShowAllComment(){
        print("clicked")
        delegateCommentOptions?.onLblCommentClicked(comment: self.comment)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    
    @objc func handleAttach(){
        print("clicked")
        delegateCommentOptions?.onAttachClicked(comment: self.comment)
        
    }
    
    
    @objc func handleReply(){
        print("clicked")
        delegateCommentOptions?.onReplyClicked(comment: self.comment)
        
    }
    
    
    func setComment(comment: Comment?){
        self.comment = comment
    }
    
    
}
