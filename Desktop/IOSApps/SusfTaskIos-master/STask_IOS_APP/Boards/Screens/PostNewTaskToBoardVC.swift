//
//  PostNewTaskToBoardVC.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 6/13/20.
//  Copyright © 2020 Susfweb. All rights reserved.
//

import UIKit
import Alamofire
import YPImagePicker
import ImagePicker
import Lightbox
import SwiftyJSON
import Loaf
import CircularProgressBar
import SwiftyAvatar
import GrowingTextView
import LetterAvatarKit
import DTZFloatingActionButton
import Malert
import HSSearchable
import GoneVisible
import CoreGraphics
import InitialsImageView
import ViewAnimator
//import TagListView
//import SSCTaglistView
import SSCustomTabbar

class PostNewTaskToBoardVC: UIViewController {
    var malert: Malert?
    
    var searchBarFilterUsers: UISearchBar?
    var usersData = SearchableWrapper()
    var tableViewUsers: UITableView?
    let tableUserCellId = "CellUser"
    var scrollTagsView: UIScrollView?
    var tagListView: TagListView?
    //    var allUsers: [UserAll] {
    //        return self.usersData.dataArray as! [UserAll]
    //    }
    var tappedIndexPath: IndexPath?
    
    var selectedUsers: [UserAll]? = []
    var isSearching = false;
    var usersCommas: String = ""
    var dateFormate = "MM/dd/yyyy"
    //    var dateFormate = "dd/MM/yyyy"
    var selectedStatusId: String = ""
    var selectedUsersTags: [UserAll]? = []
    @IBOutlet weak var tagsListView: TagListView!
    @IBOutlet weak var status: UITextField!
    var flagUsersOrStatus: Bool = true;
    let datePicker = UIDatePicker()
    var statusData: [TaskStatus]?
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var endDate: UITextField!
    @IBOutlet weak var startDate: UITextField!
    var isPrivate: Bool = true;
    
    var users: [UserHere]? = []
    var searchUsers: [UserHere]? = []
    
    var tasksGroupId: String = ""
    let headers: HTTPHeaders = [
        .accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
        .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
        .init(name: "tz", value: TimeZone.current.identifier)
        ,
        
    ]
    @IBOutlet weak var meetingLink: UITextField!
    @IBOutlet weak var meetingTime: UITextField!
    @IBOutlet weak var selectedUsersTextField: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createStartDatePicker()
        createEndDatePicker()
        createMeetingDateTimePicker()
        
        
        
        getAllAvailableStatus()
        
        
        tagsListView.delegate = self;
        
        status.delegate = self
        selectedUsersTextField.delegate = self
        
        
        
        let addImage = UIImage(systemName: "arrowshape.turn.up.right.fill")
        let addBarButtonItem = UIBarButtonItem(image: addImage, style: .done, target: self, action: #selector(postNewTaskToBoardGroup))
        self.navigationItem.rightBarButtonItems  = [addBarButtonItem]
        
        
        showMalertUsersWithFiltration()
        
    }
    
    
    @objc func postNewTaskToBoardGroup(){
        
        
        
        
        
        let tasksGroupId = self.tasksGroupId;
        let assignee = self.usersCommas;
        let name = self.name.text;
        let isPrivate = self.isPrivate;
        let statusId = self.status.text;
        let startDate = self.startDate.text;
        let dueDate = self.endDate.text;
        let meetingUrl = self.meetingLink.text;
        let meetingTime = self.meetingTime.text;
//
        
    
        
        if name!.isEmpty {
            self.view.makeToast(NSLocalizedString("enter_name", comment: ""))
        }else{
            if statusId!.isEmpty {
                self.view.makeToast(NSLocalizedString("enter_status", comment: ""))
            }else{
                if startDate!.isEmpty {
                    self.view.makeToast(NSLocalizedString("enter_start_date", comment: ""))
                }else{
                    if dueDate!.isEmpty {
                        self.view.makeToast(NSLocalizedString("enter_end_date", comment: ""))
                    }else{
                        if meetingUrl!.isEmpty {
                            self.view.makeToast(NSLocalizedString("enter_meeting_link", comment: ""))
                        }else{
                            if !(meetingUrl?.isValidURL())! {
                                self.view.makeToast(NSLocalizedString("enter_valid_link", comment: ""))
                                
                            }else{
                                if meetingTime!.isEmpty {
                                    self.view.makeToast(NSLocalizedString("enter_meet_time", comment: ""))
                                }else{
                                    postNewTask()
                                }
                            }
                        }
                    }
                }
            }
        }
        
        
        
    }
    
    
    func createSelectedUsersPicker(){
        
        //toolbar
        //        let toolBar = UIToolbar()
        //        toolBar.sizeToFit()
        //        toolBar.isUserInteractionEnabled = true;
        //
        //        //bar button
        //        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedSelectedUser))
        //        toolBar.setItems([done], animated:  true)
        //
        //
        //        //assign toolbar
        //        selectedUsers.inputAccessoryView = toolBar
        //
        //
        //        //date picker mode
        //        //        datePicker.datePickerMode = .date
        //
        //        let pickerView = UIPickerView()
        //        pickerView.delegate = self;
        //        pickerView.dataSource = self;
        //
        //        //assign the ate picker to the textfield
        //        selectedUsers.inputView = pickerView
        //
    }
    
    func createAvailabelStatusDataPicker(){
        
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true;
        
        //bar button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedSelectedStatus))
        toolBar.setItems([done], animated:  true)
        
        
        //assign toolbar
        status.inputAccessoryView = toolBar
        
        
        //date picker mode
        //        datePicker.datePickerMode = .date
        
        let pickerView = UIPickerView()
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        //assign the ate picker to the textfield
        status.inputView = pickerView
        
    }
    
    func createMeetingDateTimePicker(){
        
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true;
        
        //bar button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedDateTimeMeeting))
        toolBar.setItems([done], animated:  true)
        
        
        //assign toolbar
        meetingTime.inputAccessoryView = toolBar
        
        //assign the ate picker to the textfield
        meetingTime.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .dateAndTime
        
    }
    
    func createStartDatePicker(){
        
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true;
        
        //bar button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedStartDate))
        toolBar.setItems([done], animated:  true)
        
        
        //assign toolbar
        startDate.inputAccessoryView = toolBar
        
        //assign the ate picker to the textfield
        startDate.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        
    }
    
    func createEndDatePicker(){
        
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        //bar button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedEndDate))
        toolBar.setItems([done], animated:  true)
        toolBar.isUserInteractionEnabled = true;
        
        //assign toolbar
        endDate.inputAccessoryView = toolBar
        
        //assign the ate picker to the textfield
        endDate.inputView = datePicker
        
        //date picker mode
        datePicker.datePickerMode = .date
        
    }
    
    @IBAction func isPrivateOnValChanged(_ sender: UISegmentedControl) {
        
        if sender.selectedSegmentIndex == 0 {
            //private
            self.isPrivate = true;
        }else{
            //public
            self.isPrivate = false;
        }
        
        
    }
    
    
    
    @objc func donePressedSelectedStatus(){
        //        let formatter = DateFormatter()
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        //        //startDate.text = "\(datePicker.date)"
        //        startDate.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func donePressedSelectedUser(){
        //        let formatter = DateFormatter()
        //        formatter.dateStyle = .medium
        //        formatter.timeStyle = .none
        //        //startDate.text = "\(datePicker.date)"
        //        startDate.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func donePressedStartDate(){
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .none
        formatter.dateFormat = self.dateFormate
        //startDate.text = "\(datePicker.date)"
        startDate.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    
    @objc func donePressedDateTimeMeeting(){
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .none
        //formatter.dateFormat = "MM/dd/yyyy HH:mm:ss"
        formatter.dateFormat = "\(self.dateFormate) HH:mm:ss"
        //startDate.text = "\(datePicker.date)"
        meetingTime.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    @objc func donePressedEndDate(){
        let formatter = DateFormatter()
        //formatter.dateStyle = .medium
        //formatter.timeStyle = .none
        formatter.dateFormat = self.dateFormate
        //startDate.text = "\(datePicker.date)"
        endDate.text = "\(formatter.string(from: datePicker.date))"
        self.view.endEditing(true)
    }
    
    
    func getAllAvailableStatus(){
        self.showLoading()
        let headers: HTTPHeaders = [
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String)
            ,
            .init(name: "tz", value: TimeZone.current.identifier)
            
        ]
        //           let url = Constants.BASE_URL + Constants.Ends.END_POINT_GET_STATUS_IDS
        let url = Constants.BASE_URL  + "taskstatus"
        debugPrint(url)
        AF.request(url,method: .get,
                   headers: headers)
            .response { response in
                switch response.result {
                case .success(let data):
                    debugPrint( "Success_get_All_status: \(response.value)")
                    self.stopLoading()
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        debugPrint(swiftyData)
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let statusData = try decoder.decode(StatusData.self, from: data)
                            self.statusData = statusData.data.taskStatusData
                            //                            for n in 0...self.statusData!.count-1 {
                            //                                debugPrint(self.statusData![n].isDone)
                            //                            }
                            
                            
                            
                            
                        } catch let error {
                            print("error \(error)")
                        }
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    self.stopLoading()
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
                
        }
        
        
        
    }
    
    
    
    func showLoading(){
        self.view.makeToastActivity(.center)
    }
    
    func stopLoading(){
        self.view.hideToastActivity()
    }
    
    
    func postNewTask(){
        
        var usersIds: [String] = []
        //        for n in 0..<self.selectedUsersTags!.count{
        //            usersIds.append(self.selectedUsersTags![n].id!)
        //        }
        
//        let cells = self.tableViewUsers!.visibleCells as! Array<UITableViewCell>
//        for n in 0..<cells.count {
//            if cells[n].accessibilityIdentifier == "true" {
//                usersIds.append(self.users![n].id!)
//                print("dkd = \(self.users![n].id!)")
//            }else{
//                print("dkd = -------")
//            }
//        }
        
        
        
        if let selectedIndexes = self.tableViewUsers?.indexPathsForSelectedRows {
    
            for n in 0..<selectedIndexes.count
            {
                usersIds.append(self.users![selectedIndexes[n].row].id!)
                print(self.users![selectedIndexes[n].row].id!)
                print("============")
            }
        }
        
        let tasksGroupId: String = self.tasksGroupId;
        let name: String  = self.name.text!;
        let isPrivate = self.isPrivate;
        let statusId : String = selectedStatusId;
        let startDate : String = self.startDate.text!;
        let dueDate: String  = self.endDate.text!;
        let meetingUrl : String = self.meetingLink.text!;
        let meetingTime : String = self.meetingTime.text!;
        
        
        //        let tasksGroupId: String = self.tasksGroupId
        //              let name: String  = self.name.text!
        //              let isPrivate = self.isPrivate
        //              let statusId : String = selectedStatusId
        //              let startDate : String = "06/14/2020"
        //              let dueDate: String  = "06/16/2020"
        //              let meetingUrl : String = self.meetingLink.text!
        //              let meetingTime :String = "06/14/2020 12:10:10"
        
        print(tasksGroupId)
        print(usersIds)
        print(name)
        print(isPrivate)
        print(statusId)
        print(startDate)
        print(dueDate)
        print(meetingUrl)
        print(meetingTime)
        
        
        let parameters: [String: Any] = [
            "tasksGroupId": "\(tasksGroupId)",
            "assignee" : "\(usersIds)",
            "name" : "\(name)",
            "isPrivate" : "\(isPrivate)",
            "statusId": "\(selectedStatusId)",
            "startDate" : "\(startDate)",
            "dueDate" : "\(dueDate)",
            "meetingUrl" : "\(meetingUrl)",
            "meetingTime" : "\(meetingTime)",
        ]
        self.view.makeToastActivity(.center)
        //        let url = Constants.BASE_URL + Constants.Inbox.END_POST_MAIL
        let url = Constants.BASE_URL + "task"
        debugPrint(url)
        AF.request(url,
                   method: .post,
                   parameters: parameters,
                   headers: headers)
            .responseJSON { response in
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: post new email \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        
                        
                        self.startDate.text = ""
                        self.endDate.text = ""
                        self.meetingTime.text = ""
                        self.meetingLink.text = ""
                        self.status.text = ""
                        self.name.text = ""
                        UtilsAlert.showSuccess(message: message)
                        
                        
                    }else{
                        print(swiftyData["errorMessages"].stringValue)
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                        //                        self.view.hideToastActivity()
                        self.view.hideAllToasts()
                        //                        self.view.hideAllToasts(includeActivity: true, clearQueue: true)
                        
                    }
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    UtilsAlert.showError(message: "Network connection error")
                    self.view.hideToastActivity()
                    
                }
        }
    }
    
    
    
    
    //    func accessTagListView(_ tagLv: TagListView){
    //        tagLv.delegate = self
    //        //        tagLv.addTag("TagListView")
    //        //        tagLv.addTag("TEAChart")
    //        //        tagLv.addTag("To Be Removed")
    //        //        tagLv!.addTag("To Be Removed")
    //        //        tagLv!.addTag("Quark Shell")
    //        //        tagLv!.removeTag("To Be Removed")
    //        //        tagLv!.addTag("On tap will be removed").onTap = { [weak self] tagView in
    //        //                self?.tagListView!.removeTagView(tagView)
    //        //            }
    //        //
    //        //        let tagView = tagLv!.addTag("gray")
    //        //        tagView.tagBackgroundColor = UIColor.gray
    //        //        tagView.onTap = { tagView in
    //        //                print("Don’t tap me!")
    //        //            }
    //        //
    //        //        tagLv!.insertTag("This should be the third tag", at: 2)
    //
    //
    //        self.tagListView = tagLv
    //    }
    
    func showMalertUsersWithFiltration(){
        
        
        var itemsFinal = [UserHere]()
        
        //        if self.selectedUsersTags!.isEmpty {
        //            itemsFinal = []
        //            print("self.selectedUsersTags!.isEmpty===1")
        //        }else{
        ////            for n  in 0..<selectedUsersTags!.count {
        ////                for k in 0..<self.users!.count {
        ////                    if (selectedUsersTags![n].id != (users![k].id)) {
        ////                        itemsFinal.append(users![k])
        ////                        users?.remove(at: k)
        ////                    }else{
        ////                        users!.append(users![k])
        ////                        itemsFinal.remove(at: k)
        ////                    }
        ////                }
        ////            }
        //
        //
        //        }
        
        //        if !itemsFinal.isEmpty {
        //            self.users = itemsFinal
        //            print("self.selectedUsersTags!.isEmpty===2")
        //
        //        }
        
        let view  = PostNewTaskRootView.instanceFromNib() as PostNewTaskRootView
        self.tableViewUsers = view.tableViewUsers
        self.tableViewUsers?.register(UINib(nibName: tableUserCellId, bundle: .main), forCellReuseIdentifier: tableUserCellId)
        self.tableViewUsers!.delegate = self;
        self.tableViewUsers!.dataSource = self;
        self.searchBarFilterUsers = view.searchBar
        self.searchBarFilterUsers!.delegate = self
        self.tableViewUsers!.reloadData()
        self.tableViewUsers?.allowsMultipleSelection = true
        
        
        
        malert = Malert(customView: view)
        let action = MalertAction(title: "Back")
        action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
        malert!.addAction(action)
        //        self.present(malert!, animated: true) {}
        malert?.onDismissMalert {
            print("dododo dismised")
            self.isSearching = false;
            itemsFinal = []
            self.view.endEditing(true)
            
            
            //            for n in 0..<self.selectedUsersTags!.count{
            //                self.tagListView?.removeTagView((self.tagListView?.tagViews[n])!)
            //            }
            
            
            
            //            let cells = self.tableViewUsers!.visibleCells as Array<UITableViewCell>
            //            for n in 0..<cells.count{
            //                if cells[n].accessibilityIdentifier == "true"{
            //self.tagListView?.addTag(self.users![n].fullName!)
            //                    print("Adding ....")
            //                }
            //            }
            
            //            for n in 0..<self.selectedUsersTags!.count{
            //
            //                self.tagListView?.addTag(self.selectedUsersTags![n].fullName!)
            //                           print("adding ")
            //                        }
            //
            
        }
    }
    
    
}

extension PostNewTaskToBoardVC: UIPickerViewDataSource, UIPickerViewDelegate,
UITextFieldDelegate{
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 1{
            //status
            self.flagUsersOrStatus = true;
            createAvailabelStatusDataPicker()
            
            
        }else{
            //selected users
            
            //            self.flagUsersOrStatus = false;
            //            createSelectedUsersPicker()
            
            //            showMalertUsersWithFiltration()
            print("selected users")
            
            self.present(malert!, animated: true) {}
            
        }
        
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        
        //        if self.flagUsersOrStatus {
        //            return self.statusData?.count
        //        }else{
        //            return 0
        //        }
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if self.flagUsersOrStatus {
            return self.statusData!.count
        }else{
            return self.users!.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if self.flagUsersOrStatus {
            return self.statusData![row].name
        }else{
            return self.users![row].fullName
        }
        return ""
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if self.flagUsersOrStatus {
            self.status.text = self.statusData![row].name
            self.selectedStatusId = self.statusData![row].id
        }else{
            //            let selectedUser = self.users![row]
            //            //self.selectedUsers.text = self.users![row].name
            //            var exist: Bool = false;
            //            for n in 0..<self.selectedUsersTags!.count {
            //                if selectedUser.fullName == self.selectedUsersTags![n].fullName {
            //                    //exist
            //                    exist = true;
            //                }else{
            //                    exist = false
            //                }
            //            }
            //            if exist {
            //
            //            }else{
            //                var userHere = UserAll()
            //                userHere.shortName = selectedUser.shortName
            //                userHere.userName = selectedUser.userName
            //                userHere.fullName = selectedUser.fullName
            //                userHere.id = selectedUser.id
            //
            //                self.selectedUsersTags?.append(userHere)
            //                self.tagsListView?.addTag(selectedUser.fullName!)
            //                flagUsersOrStatus = false
            //                createSelectedUsersPicker()
            //
            //            }
            //
        }
    }
    
    
    
}


extension PostNewTaskToBoardVC: TagListViewDelegate{
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        //        tagView.isSelected = !tagView.isSelected
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        //        sender.removeTagView(tagView)
        //        for n in 0..<self.selectedUsersTags!.count {
        //            if tagView.accessibilityIdentifier == self.selectedUsersTags![n].id {
        //                self.selectedUsersTags?.remove(at: n)
        //                break
        //            }
        //        }
        //        for n in 0..<self.selectedUsersTags!.count {
        //            print("hoho  = \(self.selectedUsersTags![n].id)")
        //        }
        
        
        
    }
}


extension PostNewTaskToBoardVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching {
            return self.searchUsers!.count
            
        }else{
            return self.users!.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell: CellUser? = nil
        if (cell == nil){
            print("ggggggg")
            cell = tableView.dequeueReusableCell(withIdentifier: tableUserCellId, for: indexPath) as! CellUser
            let user: UserHere?
            if isSearching {
                user = self.searchUsers![indexPath.row]
            }else{
                user = self.users![indexPath.row]
            }
            cell!.lblUserName.text = user?.fullName
            if ( user?.userImage != nil  && !(user?.userImage!.isEmpty)! && ((user?.userImage!.starts(with: "http"))! || ((user?.userImage!.starts(with: "https")) != nil))) {
                let url = URL(string: (user?.userImage!)!)
                cell!.ivUserPhoto.kf.setImage(with: url)
            }else{
                // Circle avatar image with white border
                cell!.ivUserPhoto.image = Utils.letterAvatarImage(chars: (user?.shortName!)!)
            }
                
        }
        return cell!
    }
}

extension PostNewTaskToBoardVC: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        //        if let selectedIndexPath = self.tappedIndexPath,
        //               indexPath.row == selectedIndexPath.row {
        //            self.users?.remove(at: tappedIndexPath!.row)
        //            return 0
        //        }
        
        return 80;
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        let cell = tableView.cellForRow(at: indexPath) as! CellUser
        //        if cell.imageSelected.tag == 1{
        //           cell.imageSelected.tag =  0
        ////            cell.imageSelected.isHidden = true
        //            print("de selected")
        //        }else{
        ////            cell.accessibilityIdentifier = "true"
        //            cell.imageSelected.tag =  1
        //            print("selected")
        ////            cell.imageSelected.isHidden = false
        //        }
        
        
        let selectedUser = self.users![indexPath.row]
        //self.selectedUsers.text = self.users![row].name
        var exist: Bool = false;
        for n in 0..<self.selectedUsersTags!.count {
            //            if selectedUser.fullName == self.selectedUsersTags![n].fullName {
            if selectedUser.id == self.selectedUsersTags![n].id{
                //exist
                exist = true
                print("true")
                self.selectedUsersTags?.remove(at: n)
                break
            }else{
                exist = false
                print("false")
            }
        }
        if !exist {
            var userHere = UserAll()
            userHere.shortName = selectedUser.shortName
            userHere.userName = selectedUser.userName
            userHere.fullName = selectedUser.fullName
            userHere.id = selectedUser.id
            
            self.selectedUsersTags?.append(userHere)
            let tagView = TagView(title: selectedUser.fullName!)
            tagView.tagBackgroundColor = .blue
            tagView.cornerRadius = 5
            tagView.borderColor = .white
            tagView.borderWidth = 2;
            tagView.enableRemoveButton = true;
            tagView.onTap = { tag in
                print("Clicked")
                for n  in 0..<self.selectedUsersTags!.count {
                    if tag.accessibilityIdentifier == self.selectedUsersTags![n].id{
                        self.selectedUsersTags?.remove(at: n)
                        break
                    }
                }
                self.tagListView?.removeTagView(tag)
            }
            
            tagView.accessibilityIdentifier = selectedUser.id
            self.tagsListView?.addTag(selectedUser.fullName!)
            //            self.tagsListView?.addTagView(tagView)
            
            //            flagUsersOrStatus = false
            //            createSelectedUsersPicker()
            //
            
            
            
        }else{
            
            
        }
        
        //        self.tappedIndexPath = indexPath
        //        self.tableViewUsers!.reloadData()
        
        
//        if tableView.cellForRow(at: indexPath)?.accessoryType == UITableViewCell.AccessoryType.checkmark{
//            tableView.cellForRow(at: indexPath)?.accessoryType =  UITableViewCell.AccessoryType.none
//        }else{
//            tableView.cellForRow(at: indexPath)?.accessoryType =  UITableViewCell.AccessoryType.checkmark
//        }
        
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return  false
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        if (editingStyle == .delete) {
        //            // handle delete (by removing the data from your array and updating the tableview)
        //        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        //        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
        //            //handle delete
        //            //self.view.makeToast("delete")
        //            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
        //            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
        //                print("Handle Ok logic here")
        //                //                self.attachDelete(attach: self.attachments![indexPath.row])
        //
        //            }))
        //            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
        //                print("Handle Cancel Logic here")
        //            }))
        //            self.present(deleteConfirmation, animated: true) {}
        //        })
        //        deleteAction.image = UIImage(named: "delete_24")
        //        deleteAction.backgroundColor = .white
        //
        
        //        let currentAttachtId = self.attachments![indexPath.row].byId.rawValue
        //        let currentUserId = Utils.fetchSavedUser()?.data.user.id
        //        print(currentUserId)
        //        print(currentAttachtId)
        //        if currentUserId != currentAttachtId {
        //            return UISwipeActionsConfiguration(actions: [])
        //        }else{
        //            return UISwipeActionsConfiguration(actions:
        //                [deleteAction])
        //
        //        }
        
        return UISwipeActionsConfiguration(actions: [])
        
    }
}


extension PostNewTaskToBoardVC: UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
        
    }
}

extension PostNewTaskToBoardVC: UISearchBarDelegate{
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        self.isSearching = false
        searchBar.text = ""
        self.tableViewUsers?.reloadData()
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText.isEmpty {
            
            self.isSearching = false;
        }else{
            searchUsers = self.users?.filter {
                ($0.fullName!.localizedCaseInsensitiveContains(searchText) || $0.fullName!.localizedCaseInsensitiveContains(searchText))
                
            }
            self.isSearching = true;
        }
        
        self.tableViewUsers?.reloadData()
    }
    
}

