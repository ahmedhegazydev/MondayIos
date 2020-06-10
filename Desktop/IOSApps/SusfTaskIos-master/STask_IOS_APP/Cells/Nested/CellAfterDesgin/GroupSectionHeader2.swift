//
//  GroupSectionHeader2.swift
//  ImageSlider
//
//  Created by A on 4/13/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import TextImageButton


protocol DelegateAttachGroupSection {
    func onGroupSecAttachClicked(task: TasksGroup?)
    func onShowllUsersClicked(task: TasksGroup?)
    
}

class GroupSectionHeader2: UITableViewHeaderFooterView {
    
    @IBOutlet weak var btnShowAttachments: UIImageView!
    
    @IBOutlet weak var btnShowllUsers: UIImageView!
//    @IBOutlet weak var ivShowAttachments: TextImageButton!
//    @IBOutlet weak var ivShowUsers: TextImageButton!
    @IBOutlet weak var teamName: UILabel!
    var task: TasksGroup?
    internal var delegateAttach: DelegateAttachGroupSection?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.btnShowllUsers?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAllUsers)))
        self.btnShowllUsers.isUserInteractionEnabled = true
        
        self.btnShowAttachments?.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(showAtachments)))
        self.btnShowAttachments.isUserInteractionEnabled = true
    }
    
    @objc func showAtachments(_ sender: UITapGestureRecognizer?){
        delegateAttach?.onGroupSecAttachClicked(task: self.task)
        //        self.lblTaskDate.text = Utils.pureDate(dateBefore: self.task?.startDate)
        
    }
    
    @objc func showAllUsers(_ sender: UITapGestureRecognizer?){
        delegateAttach?.onShowllUsersClicked(task: self.task)
    }
    
    
    func seTask(task: TasksGroup?){
        self.task = task
    }
    
    
    
    
}
