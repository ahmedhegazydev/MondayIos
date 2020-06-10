//
//  PostNewComment.swift
//  ImageSlider
//
//  Created by Ahmed ElWa7sh on 4/22/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation
import UIKit

protocol ProtocolAddNewComment {
    func onPostComment()
    func onImageAttachClicked()
}

class PostNewComment: UIView{
    
    var delegate: ProtocolAddNewComment?
    @IBOutlet weak var tfEnterCOmment: UITextView!

    @IBOutlet weak var containerMentions: UIView!
    
    @IBOutlet weak var ivAttach: UIImageView!
    class func instanceFromNib() -> PostNewComment {
        return UINib(nibName: "PostNewComment", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! PostNewComment
    }
    
    
    override func awakeFromNib() {
        
        
        self.ivAttach.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOnIvAttachClicked)))
        self.ivAttach.isUserInteractionEnabled = true
        
        
        
    }
    
    @objc func handleOnIvAttachClicked(){
        print("clicked")
        delegate?.onImageAttachClicked()
    }
    
    @IBAction func btnPostCommentNow(_ sender: UIButton) {
        print("ssdsss")
        delegate?.onPostComment()
        
        
    }
    
}
