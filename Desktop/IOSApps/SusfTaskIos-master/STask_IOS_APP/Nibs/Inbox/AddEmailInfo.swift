//
//  AddEmailInfo.swift
//  ImageSlider
//
//  Created by A on 4/11/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import Toast_Swift
//import TagListView
//import SSCTaglistView

protocol ProtocolPostNewEmail {
    func onPostBtnClicked(view: UIView, inbox: Inbox?)
    func onBtnCloseClicked()
}

class AddEmailInfoView: UIView{
    
    
    //@IBOutlet weak var tagsContainer: UIView!
    @IBOutlet  var tagsListView: TagListView!
//    @IBOutlet weak var tagsCollectionView: TaglistCollection!
    
    @IBOutlet weak var scrollTagsView: UIScrollView!
    @IBOutlet weak var containerUserAndTags: UIStackView!
    @IBOutlet weak var tableContainer: UIView!
    @IBOutlet weak var lblTo: UILabel!
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableViewUsers: UITableView!
    @IBOutlet weak var etEnterTitle: UITextField!
    @IBOutlet weak var etEnterBody: UITextField!
    var delegate: ProtocolPostNewEmail?
    
    class func instanceFromNib() -> AddEmailInfoView {
        return UINib(nibName: "AddEmailInfo", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! AddEmailInfoView
    }
    
    
    override class func awakeFromNib() {
        
    }
    
    @IBAction func btnPostNewEmail(_ sender: UIButton) {
        
        if let data = UserDefaults.standard.value(forKey: Constants.INBOX_SELECTED_RECIPIENTS) as? Data {
            let allRecipents = try? PropertyListDecoder().decode(Array<UserAll>.self, from: data)
            if allRecipents!.isEmpty {
                self.makeToast("Select one recipient as minimu")
                return
            }
        }else{
            self.makeToast("Select one recipient as minimu")
            return
        }
        
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

