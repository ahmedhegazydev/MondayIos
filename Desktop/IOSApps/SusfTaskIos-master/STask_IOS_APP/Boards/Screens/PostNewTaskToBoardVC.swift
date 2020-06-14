//
//  PostNewTaskToBoardVC.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 6/13/20.
//  Copyright © 2020 Susfweb. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import MaterialActivityIndicator
import SSCustomTabbar



class PostNewTaskToBoardVC: UIViewController {
    
    
    var usersCommas: String = ""
    //    var dateFormate = "MM/dd/yyyy"
    var dateFormate = "dd/MM/yyyy"
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
    var tasksGroupId: String = ""
    let headers: HTTPHeaders = [
        //.accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
        .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
        .init(name: "tz", value: TimeZone.current.identifier)
        ,
        
    ]
    @IBOutlet weak var meetingLink: UITextField!
    @IBOutlet weak var meetingTime: UITextField!
    @IBOutlet weak var selectedUsers: UITextField!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        createStartDatePicker()
        createEndDatePicker()
        createMeetingDateTimePicker()
        
        //        self.flagUsersOrStatus = true;
        //        createAvailabelStatusDataPicker()
        //
        //
        //        self.flagUsersOrStatus = false;
        //        createSelectedUsersPicker()
        
        
        getAllAvailableStatus()
        
        
        tagsListView.delegate = self;
        
        status.delegate = self
        selectedUsers.delegate = self
        
        
    }
    
    
    func createSelectedUsersPicker(){
        
        //toolbar
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        toolBar.isUserInteractionEnabled = true;
        
        //bar button
        let done = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(donePressedSelectedUser))
        toolBar.setItems([done], animated:  true)
        
        
        //assign toolbar
        selectedUsers.inputAccessoryView = toolBar
        
        
        //date picker mode
        //        datePicker.datePickerMode = .date
        
        let pickerView = UIPickerView()
        pickerView.delegate = self;
        pickerView.dataSource = self;
        
        //assign the ate picker to the textfield
        selectedUsers.inputView = pickerView
        
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
    
    @IBAction func btnAddNewTask(_ sender: Any) {
        
        
        let tasksGroupId = self.tasksGroupId;
        let assignee = self.usersCommas;
        let name = self.name.text;
        let isPrivate = self.isPrivate;
        let statusId = self.status.text;
        let startDate = self.startDate.text;
        let dueDate = self.endDate.text;
        let meetingUrl = self.meetingLink.text;
        let meetingTime = self.meetingTime.text;
        if name!.isEmpty {
            self.view.makeToast("Enter name")
        }else{
            if statusId!.isEmpty {
                self.view.makeToast("Enter status")
            }else{
                if startDate!.isEmpty {
                    self.view.makeToast("Enter start date")
                }else{
                    if dueDate!.isEmpty {
                        self.view.makeToast("Enter end date")
                    }else{
                        if meetingUrl!.isEmpty {
                            self.view.makeToast("Enter meeting link")
                        }else{
                            if !(meetingUrl?.isValidURL())! {
                                self.view.makeToast("Enter valid meeting link")
                            }else{
                                if meetingTime!.isEmpty {
                                    self.view.makeToast("Enter meeting time")
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
    
    
    func postNewTask(){
        
        
        
        
        
        self.usersCommas = usersCommas.trimmingCharacters(in: .whitespacesAndNewlines)
        
        
        
        let tasksGroupId: String = self.tasksGroupId;
        let assignee : String = self.usersCommas;
        let name: String  = self.name.text!;
        let isPrivate = self.isPrivate;
        let statusId : String = selectedStatusId;
        let startDate : String = self.startDate.text!;
        let dueDate: String  = self.endDate.text!;
        let meetingUrl : String = self.meetingLink.text!;
        let meetingTime : String = self.meetingTime.text!;
        
        print(tasksGroupId)
        print(assignee)
        print(name)
        print(isPrivate)
        print(statusId)
        print(startDate)
        print(dueDate)
        print(meetingUrl)
        print(meetingTime)
        
        
        let parameters: [String: Any] = [
            
            "tasksGroupId": "\(tasksGroupId)",
            "assignee" : "\(usersCommas)",
            "name" : "\(name)",
            "isPrivate" : "\(isPrivate)",
            "statusId": "\(selectedStatusId)",
            "startDate" : "\(startDate)",
            "dueDate" : "\(endDate)",
            "meetingUrl" : "\(meetingLink)",
            "meetingTime" : "\(meetingTime)",
            
        ]
        
        self.view.makeToastActivity(.center)
        //        let url = Constants.BASE_URL + Constants.Inbox.END_POST_MAIL
        let url = Constants.BASE_URL + "task"
        
        debugPrint(url)
        AF.request(url,method: .post, parameters: parameters,
                   headers: headers)
            //.response { response in
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
                        
                        
                        
                        
                    }else{
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
            
            self.flagUsersOrStatus = false;
            createSelectedUsersPicker()
            
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
            let selectedUser = self.users![row]
            //self.selectedUsers.text = self.users![row].name
            
            var exist: Bool = false;
            for n in 0..<self.selectedUsersTags!.count {
                if selectedUser.fullName == self.selectedUsersTags![n].fullName {
                    //exist
                    exist = true;
                }else{
                    exist = false
                }
            }
            if exist {
                
            }else{
                var userHere = UserAll()
                userHere.shortName = selectedUser.shortName
                userHere.userName = selectedUser.userName
                userHere.fullName = selectedUser.fullName
                userHere.fullName = selectedUser.fullName
                
                self.selectedUsersTags?.append(userHere)
                self.tagsListView?.addTag(selectedUser.fullName!)
                flagUsersOrStatus = false
                createSelectedUsersPicker()
                
                
                
            }
            
        }
    }
    
    
    
}


extension PostNewTaskToBoardVC: TagListViewDelegate{
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        for n in 0..<self.selectedUsersTags!.count {
            if title == self.selectedUsersTags![n].email {
                self.selectedUsersTags?.remove(at: n)
                break
            }
        }
        for n in 0..<self.selectedUsersTags!.count {
            print("hoho  = \(self.selectedUsersTags![n].email)")
        }
        
        //saving
        //        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.selectedUsersTags), forKey: Constants.INBOX_SELECTED_RECIPIENTS)
        
        
    }
}
