//
//  AddEmailInfo.swift
//  ImageSlider
//
//  Created by A on 4/11/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import Toast_Swift


class AddEmailInfoReplyView: UIView{
    
    @IBOutlet weak var etEnterTitle: UITextField!
    @IBOutlet weak var etEnterBody: UITextField!
    
    var delegate: ProtocolPostNewEmail?
    
    class func instanceFromNib() -> AddEmailInfoReplyView {
        return UINib(nibName: "AddEmailInfoReplyView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddEmailInfoReplyView
    }
    
    @IBAction func btnPostNewEmail(_ sender: UIButton) {
        
        if etEnterTitle.text!.isEmpty{
            self.makeToast("Enter title")
            return
        }
        
        if etEnterBody.text!.isEmpty{
            self.makeToast("Enter body")
            return
        }
        
        self.delegate?.onPostBtnClicked(view: self, inbox: Inbox(title: etEnterTitle.text!, body: self.etEnterBody.text!))
        self.makeToastActivity(.center)
        
    }
    
    
    
    @IBAction func btnClose(_ sender: Any) {
        self.delegate?.onBtnCloseClicked()
    }
    
}

