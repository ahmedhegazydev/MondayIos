//
//  ReplyViewController.swift
//  ImageSlider
//
//  Created by A on 4/7/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import Alamofire
import YPImagePicker
import ImagePicker
import Lightbox
import Foundation
import SwiftyJSON
import Loaf
import CircularProgressBar
import SwiftyAvatar
import GrowingTextView
import LetterAvatarKit
import SSCustomTabbar
import Malert




@available(iOS 13.0, *)
class ReplyViewController: UIViewController
    //,UITextFieldDelegate, UITextViewDelegate
{
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
        
    }()
    @IBOutlet weak var lblDate: UILabel!
    let headers: HTTPHeaders = [
        .accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
         .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
         .init(name: "tz", value: TimeZone.current.identifier)
,
         
    ]
    @IBOutlet weak var containerMentions: UIView!
    var oeMentions:OEMentions!
    //    let cellReusableId = "CellCommentWithoutReply"
    let cellReusableId = "CellCommentWithoutReply2"
    var typeBorTorC: String = ""
    var idBorTorC: String = ""
    //var mensions: [UserHere]? = []
    var mensions: [UserAll]? = []
    var prevComments: [Comment]? = []
    var selectedMension: UserHere?
    @IBOutlet weak var labelCurrentComment: UILabel!
    @IBOutlet weak var ivAttach: UIImageView!
    @IBOutlet weak var ivUserPhoto: SwiftyAvatar!
    @IBOutlet weak var labelUserName: UILabel!
    var comment: Comment?
    @IBOutlet weak var ivSendComment: UIImageView!
    @IBOutlet weak var etEnterComment: GrowingTextView!
    @IBOutlet weak var tableViewPrevReplies: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)) , name:UIResponder.keyboardWillHideNotification, object: nil);
        
        
        //change the color of NavigationBar
        //        self.navigationController?.navigationBar.barTintColor = Utils.hexStringToUIColor(hex: "#19AC89")
        //         self.navigationController?.navigationBar.backgroundColor = Utils.hexStringToUIColor(hex: "#19AC89")
        //        self.navigationController?.navigationBar.isTranslucent = false
        //how-to-remove-border-of-the-navigationbar-in-swift
        //        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        //        self.navigationController?.navigationBar.shadowImage = UIImage()
        
        
        
        
        
        //access fields
        labelUserName.text = comment?.byUserName
//        lblDate.text = Utils.pureDateTime(dateBefore: (comment?.addDate)!)
        lblDate.text = (comment?.addDate!)! + " " + Utils.convert24To12(comment?.addDateTime!)

        
       if let image = self.comment!.byUserImage{
            if (!(image.isEmpty) && ((image.starts(with: "http")) || ((image.starts(with: "https")) != nil))) {
                let url = URL(string: image)
                ivUserPhoto.kf.setImage(with: url)
            }else{
               
                ivUserPhoto.image = Utils.letterAvatarImage(chars: (comment?.byShortName)!);
            }
        }else{
        
        ivUserPhoto.image = Utils.letterAvatarImage(chars: (comment?.byShortName)!);
        
        }
        
        //iv attach photo click listener
        ivAttach.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(AttachPhoto)))
        ivAttach.isUserInteractionEnabled = true
        
        //sending comment btn
        ivSendComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(SendComment)))
        ivSendComment.isUserInteractionEnabled = true;
        
        labelCurrentComment.text = comment?.commentData?.htmlToString
        labelCurrentComment.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOnMainCmtClicked)))
        labelCurrentComment.isUserInteractionEnabled = true;
        
        
        
        
        
        getTheLastRepliesApi()
        //setup tableview for the prev comments
        self.tableViewPrevReplies.register(UINib(nibName: self.cellReusableId, bundle: .main
        ), forCellReuseIdentifier: cellReusableId)
        tableViewPrevReplies.delegate = self
        tableViewPrevReplies.dataSource = self
        //tableViewPrevReplies.isHidden = true;
        tableViewPrevReplies.separatorStyle = .none
        tableViewPrevReplies.refreshControl = self.refresher
        tableViewPrevReplies.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTblClick)))
        
        
        
        //        if let data = UserDefaults.standard.value(forKey:Constants.SAVED_ALL_USERS) as? Data {
        //            let allUsers = try? PropertyListDecoder().decode(Array<UserAll>.self, from: data)
        //            //self.view.makeToast("exist")
        //            print("gogo exist \(allUsers?.count)")
        //            self.mensions = allUsers
        //            for n in 0..<mensions!.count {
        //                print(self.mensions![n].fullName)
        //            }
        //            self.refreshMensionsTable()
        //        }else{
        //            getAllUsers()
        //            //self.view.makeToast("downloading")
        //            print("gogo downloading")
        //        }
        getAllUsers()
        
        
        
        
        //self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleMainViewlicked)))
        //self.etEnterComment.delegate = self
        //        self.etEnterComment.returnKeyType = UIReturnKeyType.done
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        if let tabController = self.tabBarController{
        if let tabBar = tabController.tabBar as? SSCustomTabBar{
           if tabBar.tag == 2 {
               //                    dismiss(animated: false) {}
               let movetoroot = true;
               if movetoroot {
                   navigationController?.popToRootViewController(animated: true)
               } else {
                   navigationController?.popViewController(animated: true)
               }
               tabBar.tag  = 0
           }
        }
        }
       }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        var value = -200
        switch UIDevice.current.screenType {
        case .iPhone_11Pro:
            value = -250
            print("iPhone_11Pro ")
            break
        case .iPhone_XSMax_ProMax:
            value = -250
            print("iPhone_XSMax_ProMax ")
            break
        case .iPhone_XR_11:
            print("iPhone_XR_11")
            value = -250
            break
        default:
            break
        }
        self.view.frame.origin.y = CGFloat(value) // Move view 150 points upward

    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    @objc func handleRefresh(){
        print("Handle Refresh")
        getTheLastRepliesApi()
    }
   
    @objc func handleTblClick(){
        self.view.endEditing(true)
    }
    
    @objc func handleMainViewlicked(){
        self.view.endEditing(true)
    }
    
    //    func textViewDidBeginEditing(_ textView: UITextView) {
    //        print("TextView did begin editing method called")
    //        //        self.tableViewPrevReplies.isHidden = true;
    //        //        self.containerMentions.isHidden = false;
    //
    //    }
    //
    //    // UITextField Delegates
    //    func textFieldDidBeginEditing(_ textField: UITextField) {
    //        print("TextField did begin editing method called")
    //        self.tableViewPrevReplies.isHidden = true;
    //        self.containerMentions.isHidden = false;
    //
    //
    //    }
    //    func textFieldDidEndEditing(_ textField: UITextField) {
    //        print("TextField did end editing method called\(textField.text!)")
    //    }
    //    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
    //        print("TextField should begin editing method called")
    //        return true;
    //    }
    //    func textFieldShouldClear(_ textField: UITextField) -> Bool {
    //        print("TextField should clear method called")
    //        return true;
    //    }
    //    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
    //        print("TextField should end editing method called")
    //        return true;
    //    }
    //        func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
    //            print("While entering the characters this method gets called")
    //            if (textField.text == "\n") {
    //                textField.resignFirstResponder()
    //            }
    //            return true;
    //        }
    //    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
    //        print("TextField should return method called")
    //        textField.resignFirstResponder();
    //        return true;
    //    }
    
    
    fileprivate func uploadAndSaving(image: Data?, url: String?, params: [String: Any]?, headers: HTTPHeaders?) {
        SwiftProgressBar.addCircularProgressBar(view: self.view, type: 1)
        SwiftProgressBar.setProgressColor(color: UIColor.red)
        AF.upload(multipartFormData: { multiPart in
            multiPart.append(image!, withName: "file", fileName: "file.png", mimeType: "image/png")
        }, to: url as! URLConvertible, method: .post, headers: headers)
            .uploadProgress(queue: .main, closure: { progress in
                //Current upload progress of file
                //print("Upload Progress: \(progress.fractionCompleted)")
                SwiftProgressBar.setProgress(progress: Float(progress.fractionCompleted * 100))
            })
            .responseJSON { response in
                SwiftProgressBar.hideProgressBar()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success_upload\(response.value)")
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let swifty = try JSON(data: response.data!)
                            let message = swifty["message"].stringValue
                            let status = swifty["successful"].stringValue
                            let attachKey = swifty["data"]["attachKey"].stringValue as String
                            let attachName = swifty["data"]["attachName"].stringValue as String
                            
                            //                            print(message)
                            //                            print(status)
                            //                            print(attachKey)
                            //                            print(attachName)
                            
                            self.putAttachmentGeneral(attachKey: attachKey, attachName: attachName, typeBorTorC: self.typeBorTorC, idBorTorC: self.idBorTorC)
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
        }
    }
    
    func putAttachmentGeneral(attachKey: String, attachName: String, typeBorTorC: String, idBorTorC: String){
        
        var users: [String] = []
        var isPrivate: Bool = true
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            //.contentType("application/json"),
             .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
             .init(name: "tz", value: TimeZone.current.identifier)
,
             
        ]
        let parameters: [String: Any] = [
            "attachName": "\(attachName)",
            "attachKey" : "\(attachKey)",
            "isPrivate" : "\(isPrivate)",
            "type" : "\(typeBorTorC)",
            "users" : "\(users)",
        ]
        
        print(attachName)
        print(attachKey)
        print(typeBorTorC)
        print(idBorTorC)
        print(users)
        print(isPrivate)
        
        self.view.makeToastActivity(.center)
        
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_ADD_ATTACH_GENERAL + self.idBorTorC
        debugPrint(url)
        AF.request(url,method: .put, parameters: parameters, headers: headers)
            //.response { response in
            .responseJSON { response in
                //debugPrint("resp \(response)")
                self.view.hideToastActivity()
                
                switch response.result {
                case .success(let data):
                    debugPrint( "Success put : \(response.value)")
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            let main = swiftyData["data"]
                            let addDate = main["addDate"].stringValue
                            let attachId = main["attachId"].stringValue
                            let attachName = main["attachName"].stringValue
                            let byFullName = main["byFullName"].stringValue
                            let byId = main["byId"].stringValue
                            let byShortName = main["byShortName"].stringValue
                            let byUserImage = main["byUserImage"].stringValue
                            let byUserName = main["byUserName"].stringValue
                            
                            var attachment: Attachment? = Attachment()
                            attachment?.byShortName = byShortName
                            attachment?.byFullName = byFullName
                            attachment?.addDate = addDate
                            attachment?.attachId = attachId
                            attachment?.attachName = attachName
                            attachment?.byId = byId
                            attachment?.byUserImage = byUserImage
                            attachment?.byUserName = byUserName
                            
                            //                            //self.attachments?.append(attachment!)
                            //                            self.attachments?.insert(attachment!, at: 0)
                            //
                            //                            self.tableViewAttachments.beginUpdates()
                            //                            self.tableViewAttachments.insertRows(at: [IndexPath(row: 0, section: 0) ], with: .right)
                            //                            self.tableViewAttachments.endUpdates()
                            //
                            //                            //self.tableViewAttachments.reloadData()
                            
                            //UtilsAlert.showSuccess(message: "Uplaoded success")
                            self.view.makeToast(NSLocalizedString("uploaded_success", comment: ""))
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
        }
        
    }
    
    
    func getAllUsers(){
        
        self.view.makeToastActivity(.center)
        
//        let url = Constants.BASE_URL + Constants.Ends.END_POINT_GET_ALL_USERS
        let url  = Constants.BASE_URL + "user/allusers"
        debugPrint(url)
        AF.request(url,method: .get,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: get all users \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let decoder = JSONDecoder()
                            let dataAllUsers = try decoder.decode(UserDataAll.self, from: data)
                            
                            UserDefaults.standard.set(try? PropertyListEncoder().encode(dataAllUsers.data), forKey: Constants.SAVED_ALL_USERS)
                            
                            //
                            //                            //getting the mension users
                            self.mensions = dataAllUsers.data
                            self.refreshMensionsTable()
                            
                        } catch let error {
                            print(error)
                        }
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
                
        }
        
        
        
    }
    
    func refreshMensionsTable(){
        //self.view.makeToast("\(self.mensions?.count)")
        oeMentions = OEMentions.init(containerView: containerMentions, textView: etEnterComment,
                                     //mainView: self.view,
            mainView: self.containerMentions,
            oeObjects: mensions!)
        self.oeMentions.delegate = self
        self.etEnterComment.delegate = self.oeMentions
        //etEnterComment.delegate = self
        
    }
    
    
    
    func getTheLastRepliesApi(){
        
        //self.view.makeToastActivity(.center)
        
        let commentId: String = comment!.commentId!
        print(commentId)
        
        
        //        let parameters: [String: Any] = [
        //                   "commentId": "\(commentId)",
        //                   "commentData" : "\(commentData)",
        //                   "mentionUsers" : "\(strMentionedUsers)",
        //               ]
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_SUBCOMMENTS_URL + commentId
        debugPrint(url)
        AF.request(url,method: .get,
                   //                          parameters: parameters,
            
            headers: headers)
            //.response { response in
            .responseJSON { response in
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: get prev comments \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let decoder = JSONDecoder()
                            let comment = try decoder.decode(Reply.self, from: data)
                            
                            self.prevComments =  comment.data.nestedComments
                            var noDeletedArray: [Comment]? = []
                            //self.view.makeToast("\(self.prevComments?.count)")
                            
                            for n in 0..<self.prevComments!.count {
                                if !self.prevComments![n].isDelete! {
                                    noDeletedArray?.append(self.prevComments![n])
                                }
                            }
                            self.prevComments = noDeletedArray?.reversed()
                            self.tableViewPrevReplies.reloadData()
                            if self.prevComments!.isEmpty {
                                self.tableViewPrevReplies.isHidden = true;
                            }else{
                                self.tableViewPrevReplies.isHidden = false
                            }
                            self.refresher.endRefreshing()
                            
                            
                        } catch let error {
                            print(error)
                        }
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
                
        }
        
    }
    
    @objc func AttachPhoto(){
        
        //        var config = Configuration()
        //        config.doneButtonTitle = "Finish"
        //        config.noImagesTitle = "Sorry! There are no images here!"
        //        config.recordLocation = false
        //        config.allowVideoSelection = true
        //        let imagePicker = ImagePickerController(configuration: config)
        //        imagePicker.delegate = self
        //        present(imagePicker, animated: true, completion: nil)
        
        
        
        let name = "Board"
        // let name = "Comments"
        let attachmentsVc = UIStoryboard(name: name, bundle: .main).instantiateViewController(identifier: "AttachmentsVCId") as AttachmentsViewController
        attachmentsVc.attachments = comment?.attachments as! [Attachment]
        attachmentsVc.idBorTorC = comment?.commentId as! String
        attachmentsVc.typeBorTorC = "c"
        //self.present(attachmentsVc, animated: true) {}
        self.navigationController?.pushViewController(attachmentsVc, animated: true)
        
    }
    
    @objc func SendComment(){
        //self.view.makeToast("sending comment")
        if !etEnterComment.text.isEmpty {
            sendComment()
        }else{
            self.view.makeToast(NSLocalizedString("enter_comment", comment: ""))
        }
        
        
    }
    
    @objc func handleOnMainCmtClicked(){
        let alert = UIAlertController(title: Constants.APP_NAME, message: labelCurrentComment.text, preferredStyle: .alert)
                                 alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
                     //            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                                 self.present(alert, animated: true)
                      
               
            
        
     }
    
    @IBAction func btnClose(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
            
        }
    }
    
    
    func sendComment(){
        
        self.view.makeToastActivity(.center)
        
        var mentionedUsersIds: [String] =  []
        var strMentionedUsers: String
        //get the mentioned users from the edittext
        for n in 0..<self.mensions!.count{
            let txt = self.etEnterComment.text
            if(txt!.contains("\(self.mensions![n].fullName)")){
                mentionedUsersIds.append(self.mensions![n].id!)
            }
        }
        
        let commentId: String = comment!.commentId!
        let commentData: String = self.etEnterComment.text
        strMentionedUsers =  mentionedUsersIds.joined(separator:",")
        print(commentId)
        print(commentData)
        print(strMentionedUsers)
        
        
        let parameters: [String: Any] = [
            "commentId": "\(commentId)",
            "commentData" : "\(commentData)",
            "mentionUsers" : "\(strMentionedUsers)",
        ]
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_ADD_SUB_COMMENT
        debugPrint(url)
        AF.request(url,method: .post, parameters: parameters, headers: headers)
            //.response { response in
            .responseJSON { response in
                switch response.result {
                case .success(let data):
                    debugPrint( "Success_sending_comment: \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        self.refreshMensionsTable()

                        do {
                            
                            self.view.makeToast(NSLocalizedString("reply_add_success", comment: ""))
                            
                            self.etEnterComment.text = ""
                            self.view.hideToastActivity()
                            
                            
                            let main = swiftyData["data"]
                            let addDate = main["addDate"].stringValue
                            let attachments = main["attachments"].arrayValue as? [Attachment]
                            print("attahchmentsJO = \(attachments)")
                            let byFullName = main["byFullName"].stringValue
                            let byId = main["byId"].stringValue
                            let byShortName = main["byShortName"].stringValue
                            let byUserImage = main["byUserImage"].stringValue
                            let byUserName = main["byUserName"].stringValue
                            //let commentData = main["commentData"].stringValue
                            let commentId = main["commentId"].stringValue
                            let taskId = main["taskId"].stringValue
                            
                            var cmt: Comment? = Comment()
                            cmt?.addDate = addDate
                            cmt?.attachments = attachments
                            cmt?.byFullName = byFullName
                            cmt?.byId = byId
                            cmt?.byShortName = byShortName
                            cmt?.byUserImage = byUserImage
                            cmt?.byUserName = byUserName
                            cmt?.commentData = commentData
                            cmt?.commentId = commentId
                            //cmt?.taskId = taskId
                            
                            //self.comments?.append(cmt!)
                            self.prevComments?.insert(cmt!, at: 0)
                            //self.comments?.reverse()
                            
                            self.tableViewPrevReplies.isHidden = false
                            self.tableViewPrevReplies.beginUpdates()
                            self.tableViewPrevReplies.insertRows(at: [IndexPath(row: 0, section: 0) ], with: .right)
                            self.tableViewPrevReplies.endUpdates()
                            
                            
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                        self.view.hideToastActivity()

                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    UtilsAlert.showError(message: "Network connection error")
                    self.view.hideToastActivity()

                }
                
                
        }
        
        
    }
    
    
    func commentDelete(comment: Comment?, indexPath: IndexPath, pos: Int){
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_DELETE_SUB_COMMENT + (comment?.commentId)!
        debugPrint("ooosd" + url)
        AF.request(url,method: .delete, headers: headers)
            //.response { response in
            .responseJSON { response in
                //debugPrint("resp \(response)")
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success put : \(response.value)")
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        UtilsAlert.showSuccess(message: message)
                        
                        guard let data = response.data else { return }
                        do {
                            
                            
                            self.prevComments?.remove(at: pos)
                            self.tableViewPrevReplies.beginUpdates()
                            self.tableViewPrevReplies.deleteRows(at: [indexPath], with: .left)
                            self.tableViewPrevReplies.endUpdates()
                            self.tableViewPrevReplies.reloadData()
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
        }
        
    }
    
    public func alertWithTextField(title: String? = nil, message: String? = nil, placeholder: String? = nil, text: String? = nil, completion: @escaping ((String) -> Void) = { _ in }) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addTextField() { newTextField in
            newTextField.placeholder = placeholder
            newTextField.text = text
        }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel) { _ in //completion("")
            
        })
        alert.addAction(UIAlertAction(title: "Submit", style: .default) { action in
            if
                let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        navigationController?.present(alert, animated: true)
    }
    
    
    
    func commentEdit(commentData: String, comment: Comment, _ pos: Int){
        
        var commentId: String = ""
        var mentionedUsers: [UsersmentionID]? = nil
        
        commentId =  comment.commentId!
        mentionedUsers = comment.usersmentionId
        
        print(commentId)
        print(mentionedUsers)
        print(commentData)
        
        let parameters: [String: Any] = [
            "commentData": "\(commentData)",
            "mentionUsers" : "\(mentionedUsers)",
        ]
        
        
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_DELETE_SUB_COMMENT + (comment.commentId)!
        debugPrint(url)
        AF.request(url,method: .put, parameters: parameters,  headers: headers
        )
            //.response { response in
            .responseJSON { response in
                //debugPrint("resp \(response)")
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success put : \(response.value)")
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        UtilsAlert.showSuccess(message: "Comment updated success")
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let commentData = try decoder.decode(CommentAddData.self, from: data)
                            var comment = commentData.data
                            
                            var cmt = self.prevComments![pos]
                            comment.addDate = cmt.addDate
                            comment.updateDate = cmt.updateDate
                            comment.deleteDate = cmt.deleteDate
                            comment.attachments = cmt.attachments
                            self.prevComments![pos] = comment
                            self.tableViewPrevReplies.reloadData()
                            
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                    }
                    
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
        }
        
    }
    
}


@available(iOS 13.0, *)
extension ReplyViewController: ImagePickerDelegate{
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        imagePicker.dismiss(animated: true, completion: nil)
    }
    
    func wrapperDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        guard images.count > 0 else { return }
        
        let lightboxImages = images.map {
            return LightboxImage(image: $0)
        }
        
        let lightbox = LightboxController(images: lightboxImages, startIndex: 0)
        imagePicker.present(lightbox, animated: true, completion: nil)
        
        
    }
    
    func doneButtonDidPress(_ imagePicker: ImagePickerController, images: [UIImage]) {
        print("fetched images")
        imagePicker.dismiss(animated: true, completion: nil)
        let firestImage = images[0]
        
        //beginUpload(firestImage)
        
        
        
        
        
    }
    
    fileprivate func beginUpload(_ firestImage: UIImage) {
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            
            .contentType("multipart/form-data"),
             .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
             .init(name: "tz", value: TimeZone.current.identifier)
,
             
        ]
        let url = Constants.BASE_URL +  Constants.Uplaoding.END_POINT_UPLOAD_FILE
        uploadAndSaving(image: firestImage.pngData(), url: url, params: nil, headers: headers)
    }
    
    
}

@available(iOS 13.0, *)
extension ReplyViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.prevComments!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellCommentWithoutReply
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellCommentWithoutReply2
        let comment = self.prevComments?[indexPath.row]
        
        
        cell.setComment(comment: comment)
        cell.delegateSubCommentOptions = self
        
        
        cell.lblUserName.text = comment?.byFullName
        //        cell.lblDate.text = Utils.pureDate(dateBefore: (comment?.addDate)!)
        //        cell.lblTime.text = Utils.pureTime(dateBefore: (comment?.addDate)!)
//        cell.lblDate.text = Utils.pureDateTime(dateBefore: (comment?.addDate)!)
        cell.lblDate.text = (comment?.addDate!)! + " " + Utils.convert24To12(comment?.addDateTime!)
        
        
        if let image =  comment?.byUserImage{
            if (!(image.isEmpty) && ((image.starts(with: "http")) || ((image.starts(with: "https")) != nil))) {
                let url = URL(string: image)
                cell.ivUserImage.kf.setImage(with: url)
            }else{
               
                cell.ivUserImage.image = Utils.letterAvatarImage(chars: (comment?.byShortName)!);
            }
        }else{
        
            cell.ivUserImage.image = Utils.letterAvatarImage(chars: (comment?.byShortName)!);
            
        }
        cell.lblReplyData.text = comment?.commentData?.htmlToString
        //        cell.lblReplyData.text = "You can configure the overall appearance of a label's text, and use attributed strings to customize the appearance of substrings within the text. Add and customize labels in your interface programmatically or with the Attributes inspector in Interface Builder."
        
        return cell;
    }
}

@available(iOS 13.0, *)
extension ReplyViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 230;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.view.makeToast("\(indexPath.row)")
        //            self.selectedMension = self.mensions![indexPath.row]
        //            print(selectedMension?.name)
        //            print(selectedMension?.fullName)
        
        
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //handle delete
            //self.view.makeToast("delete")
            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                self.commentDelete(comment: self.prevComments![indexPath.row], indexPath: indexPath, pos: indexPath.row)
                
            }))
            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            self.present(deleteConfirmation, animated: true) {}
        })
        deleteAction.image = UIImage(named: "delete_24")
        deleteAction.backgroundColor = .white
        
        
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //self.view.makeToast("edit")
            let cmt = self.prevComments![indexPath.row]
            self.alertWithTextField(title: Constants.APP_NAME, message: "Edit comment", placeholder: "Enter edit", text: cmt.commentData) { (comment) in
                print(comment)
                if comment.isEmpty{
                    self.view.makeToast(NSLocalizedString("enter_comment", comment: ""))
                    return
                }
                self.commentEdit(commentData: comment, comment: cmt, indexPath.row)
            }
        })
        editAction.image = UIImage(named: "edit_24")
        editAction.backgroundColor = .white
        
        let currentCommentId = self.prevComments![indexPath.row].byId
        let currentUserId = Utils.fetchSavedUser().data.user.id
        print(currentUserId)
        print(currentCommentId)
        if currentUserId != currentCommentId {
            return UISwipeActionsConfiguration(actions: [])
        }else{
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            
        }
    }
    
    //    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
    //        if (editingStyle == .delete) {
    //            // handle delete (by removing the data from your array and updating the tableview)
    //        }
    //    }
    
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        var deleteAction = UITableViewRowAction(style: .default, title: "Delete") {action,some  in
    //            //handle delete
    //            //self.view.makeToast("delete")
    //
    //
    //            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
    //            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
    //                print("Handle Ok logic here")
    //                self.commentDelete(comment: self.prevComments![indexPath.row])
    //
    //            }))
    //            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //                print("Handle Cancel Logic here")
    //            }))
    //            self.present(deleteConfirmation, animated: true) {
    //
    //            }
    //
    //        }
    //
    //        var editAction = UITableViewRowAction(style: .normal, title: "Edit") {action,some in
    //            //handle edit
    //            //self.view.makeToast("edit")
    //            let cmt = self.prevComments![indexPath.row]
    //            self.alertWithTextField(title: Constants.APP_NAME, message: "Edit comment", placeholder: "Enter edit", text: cmt.commentData) { (comment) in
    //                print(comment)
    //                self.commentEdit(comment: cmt)
    //            }
    //        }
    //
    //        return [deleteAction, editAction]
    //    }
    
}

@available(iOS 13.0, *)
extension ReplyViewController: GrowingTextViewDelegate{
    
    func textViewDidChange(_ textView: UITextView) {
        //print(textView.text)
        
        
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        
    }
    
}

@available(iOS 13.0, *)
extension ReplyViewController: OEMentionsDelegate{
    func onMensionCharDetected(detected: Bool?) {
        //print(detected)
        if detected! {
            containerMentions.isHidden = false
            tableViewPrevReplies.isHidden = true
        }else{
            containerMentions.isHidden = true
            tableViewPrevReplies.isHidden = false
        }
    }
    
    
    func mentionSelected(user: UserAll?) {
        containerMentions.isHidden = true
        tableViewPrevReplies.isHidden = false
    }
    
    
}


extension ReplyViewController: ProtocolSubCommentOptions{
    func onLblCommentClicked(comment: Comment?) {
        
        
//        let viewRoot = CustomAlert.instanceFromNib() as CustomAlert
//               viewRoot.lblSubject.text = comment?.commentData
//                          let malert = Malert(customView: viewRoot)
//                          let action = MalertAction(title: "Ok")
//                          action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
//                          malert.addAction(action)
//                          self.present(malert, animated: true) {}
//                          //            malert?.onDismissMalert {
//                          //                print("dismised")
//                          //                self.flag = false
//                                      }
            
        
         let alert = UIAlertController(title: Constants.APP_NAME, message: comment?.commentData, preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
        //            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                    self.present(alert, animated: true)
                 
        
    }
    
    
    
    
}
