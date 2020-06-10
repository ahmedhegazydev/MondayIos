//
//  CellCommentWithoutReply2.swift
//  ImageSlider
//
//  Created by A on 4/18/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar

protocol ProtocolSubCommentOptions {
//    func onAttachClicked(comment: Comment?)
//    func onReplyClicked(comment: Comment?)
    func onLblCommentClicked(comment: Comment?)
    
}


class CellCommentWithoutReply2: UITableViewCell {

    @IBOutlet weak var lblTime: UILabel!
    @IBOutlet weak var lblDate: UILabel!
    @IBOutlet weak var ivUserImage: SwiftyAvatar!
    @IBOutlet weak var lblUserName: UILabel!
    @IBOutlet weak var lblReplyData: UILabel!
    var delegateSubCommentOptions: ProtocolSubCommentOptions?
    var comment: Comment?

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.lblReplyData.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleShowAllComment)))
                 self.lblReplyData.isUserInteractionEnabled = true;
        
        
    }

    @objc func handleShowAllComment(){
           print("clicked")
           delegateSubCommentOptions?.onLblCommentClicked(comment: self.comment)
       }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setComment(comment: Comment?){
           self.comment = comment
       }
    
}
