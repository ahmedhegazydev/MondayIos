//
//  CommentsViewController.swift
//  ImageSlider
//
//  Created by A on 4/6/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import Alamofire
import YPImagePicker
import ImagePicker
import Lightbox
import SwiftyJSON
import Loaf
import CircularProgressBar
import Malert
import SSCustomTabbar


@available(iOS 13.0, *)
class CommentsViewController: UIViewController {
    
    var tvEnterComment: UITextView?
    var containerMentions: UIView!
    var oeMentions:OEMentions!
    var flagAttachPhoto: Bool = false
    var malert: Malert?
    var newCommentAdded: Comment? = nil
    var attachName: String = "", attachKey: String = ""
    let headers: HTTPHeaders = [
        //.acceptLanguage("ar"),
        .accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
        .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
//         .acceptLanguage("ar"),
        .init(name: "tz", value: TimeZone.current.identifier),

    ]
    var mensions: [UserAll]? = []
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
        
    }()
    @IBOutlet weak var tableViewComments: UITableView!
    //let cellReusableId = "CellComment"
    let cellReusableId = "CellComment2"
    var comments: [Comment]? = []
    var task: TaskH? = nil
    var comment: Comment? = nil
    var flag: Bool = true;
    var attachment: Attachment?
    
    //@IBOutlet weak var ivClose: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        var commentsTemp: [Comment]? = []
        for n in 0..<self.comments!.count{
            let comment = self.comments![n]
            if !comment.isDelete!{
                commentsTemp?.append(comment)
            }else{
                
            }
        }
        self.comments = commentsTemp
        self.comments?.reverse()
        self.tableViewComments.register(UINib(nibName: self.cellReusableId, bundle: .main
        ), forCellReuseIdentifier: cellReusableId)
        self.tableViewComments.delegate = self
        self.tableViewComments.dataSource = self
        self.tableViewComments.reloadData()
        self.tableViewComments.separatorStyle = .none
        tableViewComments.refreshControl = self.refresher
        
        
        
        //        self.ivClose.addGestureRecognizer(UIGestureRecognizer(target: self, action: #selector(HandleTap)))
        //        self.ivClose.isUserInteractionEnabled = true;
        
        
        
        addingBarButtonItems()
        
        
        getAllUsers()
        
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        //change the color of NavigationBar
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationController?.navigationBar.backgroundColor = .white
        //self.navigationController?.navigationBar.isTranslucent = false
        
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabController = self.tabBarController
        if let  controller = tabController{
            let tabBar = controller.tabBar
            if tabBar.tag == 2{
                print("gweoweow  ")
                //  dismiss(animated: false) {}
                let movetoroot = false;
                tabBar.tag  = 0
                if movetoroot {
                    navigationController?.popToRootViewController(animated: true)
                } else {
                    navigationController?.popViewController(animated: true)
                }
                
            }
        }
         
        
    }
    
    
    func getAllUsers(){
        
        self.view.makeToastActivity(.center)
        
        //let url = Constants.BASE_URL + Constants.Ends.END_POINT_GET_ALL_USERS
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
                            
                            //getting the mension users
                            self.mensions = dataAllUsers.data
                            
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
    
    @objc func handleRefresh(){
        
        let deadLine = DispatchTime.now() + .milliseconds(500)
        DispatchQueue.main.asyncAfter(deadline: deadLine) {
            self.tableViewComments.reloadData()
            self.refresher.endRefreshing()
            
        }
        
    }
    
    func upload(image: Data?, url: String?, params: [String: Any]?, headers: HTTPHeaders?) {
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
                    debugPrint( "Success: \(response.value)")
                    
                    self.flagAttachPhoto = false
                    self.present(self.malert!, animated: true) {
                        
                    }
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        
                        //UtilsAlert.showSuccess(message: message)
                        UtilsAlert.showSuccess(message: "File uploaded success")
                        
                        self.attachName = ""
                        self.attachKey =  ""
                        
                        guard let data = response.data else { return }
                        do {
                            
                            let swifty = try JSON(data: response.data!)
                            let message = swifty["message"].stringValue
                            let status = swifty["successful"].stringValue
                            self.attachKey = swifty["data"]["attachKey"].stringValue
                            self.attachName = swifty["data"]["attachName"].stringValue
                            
                            print(message)
                            print(status)
                            print(self.attachKey)
                            print(self.attachName)
                            
                            //                            self.putAttachmentGeneral(attachKey: self.attachKey, attachName: self.attachName, typeBorTorC: "c", idBorTorC: )
                            
                            
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
//        let headers: HTTPHeaders = [
//            .accept("application/json"),
//            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
//            //.contentType("application/json"),
//             //.acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
//            .acceptLanguage("ar"),
////            .defaultAcceptLanguage,
////            "Accept-Language":"ar",
//
//        ]
             let headers: HTTPHeaders = [
                    .accept("application/json"),
                    .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
                             .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
//                .acceptLanguage("ar"),
                .init(name: "tz", value: TimeZone.current.identifier),

                
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
        
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_ADD_ATTACH_GENERAL + idBorTorC
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
                            
                            //                            self.attachment = Attachment()
                            //                            self.attachment?.byShortName = byShortName
                            //                            self.attachment?.byFullName = byFullName
                            //                            self.attachment?.addDate = addDate
                            //                            self.attachment?.attachId = attachId
                            //                            self.attachment?.attachName = attachName
                            //                            self.attachment?.byId = byId
                            //                            self.attachment?.byUserImage = byUserImage
                            //                            self.attachment?.byUserName = byUserName
                            
                            //                            //self.attachments?.append(attachment!)
                            //                            self.attachments?.insert(attachment!, at: 0)
                            //
                            //                            self.tableViewAttachments.beginUpdates()
                            //                            self.tableViewAttachments.insertRows(at: [IndexPath(row: 0, section: 0) ], with: .right)
                            //                            self.tableViewAttachments.endUpdates()
                            //
                            //                            //self.tableViewAttachments.reloadData()
                            
                            //UtilsAlert.showSuccess(message: "Uplaoded success")
                            self.view.makeToast("Uploaded success")
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
    
    
    
    func addingBarButtonItems(){
        //Adding add new comment
        //        let addSymbolConfiguration = UIImage.SymbolConfiguration(pointSize: 55, weight: .black)
        //        let addImage = UIImage(systemName: "Add", withConfiguration: addSymbolConfiguration)
        //        let width = addImage?.size.width
        //        let height = addImage?.size.height
        let addImage = UIImage(systemName: "plus")
        let addBarButtonItem = UIBarButtonItem(image: addImage, style: .done, target: self, action: #selector(addNewComment))
        //self.navigationItem.rightBarButtonItem  = addBarButtonItem
        
        
        //Adding attach button
        let attachImage = UIImage(systemName: "paperclip")
        let attachBarButtonItem = UIBarButtonItem(image: attachImage, style: .done, target: self, action: #selector(attachPhotoToComment))
        //self.navigationItem.rightBarButtonItem  = attachBarButtonItem
        
        
        //        self.navigationItem.rightBarButtonItems  = [addBarButtonItem, attachBarButtonItem]
        self.navigationItem.rightBarButtonItems  = [addBarButtonItem]
    }
    
    @objc func addNewComment(){
        //        self.alertWithTextField(title: Constants.APP_NAME, message: "Add new comment", placeholder: "Enter new comment", text: "") { (comment) in
        //            print(comment)
        //            if !comment.isEmpty{
        //                self.addNewCommentMethod(comment: comment)
        //            }
        //        }
        
        
        let viewRoot  = PostNewComment.instanceFromNib() as PostNewComment
        viewRoot.delegate = self
        malert = Malert(customView: viewRoot)
        let action = MalertAction(title: "Back")
        action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
        malert!.addAction(action)
        self.present(malert!, animated: true) {}
        malert?.onDismissMalert {
            print("dismised")
            if self.flagAttachPhoto{
                self.attachPhotoToComment()
            }
        }
        self.tvEnterComment = viewRoot.tfEnterCOmment
        self.containerMentions = viewRoot.containerMentions
        oeMentions = OEMentions.init(containerView: containerMentions, textView: viewRoot.tfEnterCOmment,
                                     //mainView: self.view,
            mainView: self.containerMentions,
            oeObjects: mensions!)
        self.oeMentions.delegate = self
        viewRoot.tfEnterCOmment.delegate = self.oeMentions
        
        
    }
    
    @objc func attachPhotoToComment(){
        var config = Configuration()
        config.doneButtonTitle = "Finish"
        config.noImagesTitle = "Sorry! There are no images here!"
        config.recordLocation = false
        config.allowVideoSelection = true
        
        
        let imagePicker = ImagePickerController(configuration: config)
        imagePicker.delegate = self
        self.present(imagePicker, animated: true, completion: nil)
    }
    
    func addNewCommentMethod(comment: String){
        var taskId: String = ""
        //var attachName: String = ""
        //var attachKey: String = ""
        var isPrivate: Bool = true
        var users: [String] = []
        var mentionUsers: String = ""
        
        taskId = "\(self.task!.id)"
        //attachName = ""
        //attachKey = ""
        isPrivate = true
        users = []
        mentionUsers = ""
        
        
        print(taskId)
        
        let parameters: [String: Any] = [
            "taskId": "\(taskId)",
            "commentData" : "\(comment)",
            "attachName" : "\(self.attachName)",
            "attachKey" : "\(self.attachKey)",
            //"attachName" : "\(self.attachment?.attachName)",
            //"attachKey" : "\(self.attachment?.attachKey)",
            "isPrivate" : "\(isPrivate)",
            "users" : "\(users)",
            "mentionUsers" : "\(mentionUsers)",
        ]
        
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_ADD_COMMENT
        debugPrint(url)
        
        self.view.makeToastActivity(.center)
        
        AF.request(url,method: .post, parameters: parameters, headers: headers)
            //.response { response in
            .responseJSON { response in
                
                self.view.hideToastActivity()
                
                switch response.result {
                case .success(let data):
                    debugPrint( "SuccessCommentAddedSuccessMan \(response.value)")
                    let swiftyData = JSON(response.value)
                    print(swiftyData)
                    //let main = swiftyData["data"]
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    self.malert?.dismiss(animated: false, completion: {
                        
                    })
                    self.attachKey = ""
                    self.attachName = ""
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        let msg = "Comment added success"
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            
                            let decoder = JSONDecoder()
                            let commentData = try decoder.decode(CommentAddData.self, from: data)
                            var addedComment = commentData.data
                            
                            //                            UtilsAlert.showSuccess(message: msg)
                            self.view.makeToast(msg)
                            
                            
                            
                            //                            print(main)
                            //                            let addDate = main["addDate"].stringValue
                            //                            print("jsdaj =  \(addDate)")
                            //                            let attachments = main["attachments"].arrayValue
                            //                            print("attahchmentsJO = \(attachments)")
                            //                            let byFullName = main["byFullName"].stringValue
                            //                            let byId = main["byId"].stringValue
                            //                            let byShortName = main["byShortName"].stringValue
                            //                            let byUserImage = main["byUserImage"].stringValue
                            //                            let byUserName = main["byUserName"].stringValue
                            //                            //let commentData = main["commentData"].stringValue
                            //                            let commentId = main["commentId"].stringValue
                            //                            let taskId = main["taskId"].stringValue
                            //
                            
                            //                             newCommentAdded: Comment? = Comment()
                            //                            newCommentAdded?.addDate = addedComment.addDate
                            //                            newCommentAdded?.attachments = addedComment.attachments
                            //                            newCommentAdded?.byFullName = addedComment.byFullName
                            //                            newCommentAdded?.byId = addedComment.byId
                            //                            newCommentAdded?.byShortName = addedComment.byShortName
                            //                            cmt?.byUserImage = addedComment.byUserImage
                            //                            cmt?.byUserName = addedComment.byUserName
                            //                            cmt?.commentData = comment
                            //                            cmt?.commentId = addedComment.commentId
                            //
                            //                            print(cmt?.addDate)
                            //                            print("sdfsdfs  = \(cmt?.attachments)")
                            //                            print(cmt?.byFullName)
                            //                            print(cmt?.byId)
                            //                            print(cmt?.byShortName)
                            //                            print(cmt?.byUserImage)
                            //                            print(cmt?.commentData)
                            //                            print(cmt?.commentId)
                            
                            
                            for n in 0..<(addedComment.attachments!.count) {
                                addedComment.attachments![n].isDelete = false
                            }
                            
                            //self.comments?.append(cmt!)
                            self.comments?.insert(addedComment, at: 0)
                            //self.comments?.reverse()
                            self.tableViewComments.beginUpdates()
                            self.tableViewComments.insertRows(at: [IndexPath(row: 0, section: 0)], with: .right)
                            self.tableViewComments.endUpdates()
                            //self.tableViewComments.reloadData()
                            
                            
                            
                            
                            
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
    
    @IBAction func btnClose(_ sender: UIButton) {
        
        self.dismiss(animated: true) {
            
        }
        
    }
    
    @objc func HandleTap(){
        self.dismiss(animated: true) {
            
        }
    }
    
    func commentDelete(comment: Comment?, indexPath: IndexPath, pos: Int){
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_COMMENTS_URL + (comment?.commentId)!
        debugPrint(url)
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
                            
                            
                            
                            self.comments?.remove(at: pos)
                            self.tableViewComments.beginUpdates()
                            self.tableViewComments.deleteRows(at: [indexPath], with: .left)
                            self.tableViewComments.endUpdates()
                            self.tableViewComments.reloadData()
                            
                            
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
            if let textFields = alert.textFields,
                let tf = textFields.first,
                let result = tf.text
            { completion(result) }
            else
            { completion("") }
        })
        navigationController?.present(alert, animated: true)
    }
    
    func commentEdit(_ commentFromUser: String, _ comment: Comment?, _ pos: Int){
        
        var commentId: String = ""
        var mentionedUsers: [UsersmentionID] = []
        //var commentData: String = ""
        
        commentId =  comment?.commentId as! String
        mentionedUsers = comment?.usersmentionId as! [UsersmentionID]
        //commentData = comment?.commentData as! String
        
        print(commentId)
        print(mentionedUsers)
        //print(commentData)
        
        let parameters: [String: Any] = [
            "commentData": "\(commentFromUser)",
            "mentionUsers" : "\(mentionedUsers)",
        ]
        
        
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_COMMENTS_URL + (comment?.commentId)!
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
                    print(swiftyData)
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
                            
                            var cmt = self.comments![pos]
                            comment.addDate = cmt.addDate
                            comment.updateDate = cmt.updateDate
                            comment.deleteDate = cmt.deleteDate
                            comment.attachments = cmt.attachments
                            comment.usersmentionId = cmt.usersmentionId
                            
                            
                            
                            self.comments![pos] = comment
                            self.tableViewComments.reloadData()
                            
                            //                            {
                            //                              "successful" : true,
                            //                              "data" : {
                            //                                "byShortName" : "SA",
                            //                                "byUserName" : "admin",
                            //                                "byId" : "U841144988571",
                            //                                "taskId" : "TI7946593858",
                            //                                "commentId" : "TIC2638561217",
                            //                                "byFullName" : "Super Admin",
                            //                                "commentData" : "Comment fff. ثثثث",
                            //                                "isDelete" : false,
                            //                                "byUserImage" : "https:\/\/mobile.susftask.com\/img\/ima-e6836926-8832-44fd-a7bc-3c7732c6f457.jpg"
                            //                              },
                            //                              "message" : "data successfully retrieved"
                            //                            }
                            
                            
                            
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
extension CommentsViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.comments!.count
        //        return 5;
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        //        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellComment
        //        cell.setComment(comment: comments![indexPath.row])
        //        cell.delegateCommentOptions = self;
        //        let cmt = self.comments![indexPath.row]
        //        cell.labelComment.text = cmt.commentData
        //        cell.labelUserName.text = cmt.byUserName?.rawValue
        //        let url = URL(string: cmt.byUserImage!)
        //        cell.ivUserPhoto.kf.setImage(with: url)
        //        //   cell.ivAttach.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAttach)))
        //        //        cell.ivAttach.isUserInteractionEnabled = true;
        //        //        cell.tag = indexPath.row
        
        
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellComment2
        cell.setComment(comment: comments![indexPath.row])
        cell.delegateCommentOptions = self;
        let cmt = self.comments![indexPath.row]
        
        
        cell.lblComment.text = cmt.commentData?.htmlToString
        
        
        
//        cell.lblUserName.text = cmt.byUserName
        cell.lblUserName.text = cmt.byFullName

        
        if let image = cmt.byUserImage {
            if (!image.isEmpty && (image.starts(with: "http") || image.starts(with: "https"))) {
                let url = URL(string: image)
                    cell.ivUserImage.kf.setImage(with: url)
                    print("linkexist")
                }else{
                    cell.ivUserImage.image =
                        Utils.letterAvatarImage(chars: cmt.byShortName!)
                    
                }
        }else{
        cell.ivUserImage.image =
            Utils.letterAvatarImage(chars: cmt.byShortName!)
            
        }
        
        let date: String? = Utils.pureDateTime(dateBefore: cmt.addDate!)
        cell.lblDate.text = date
        
        
        
        
        return cell;
    }
    
 

    
    
}

@available(iOS 13.0, *)
extension CommentsViewController: UITableViewDelegate{
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300;
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.view.makeToast("\(indexPath.row)")
        //self.flag = !flag
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        //        var flag: Bool = true;
        //        let currentCommentId = self.comments![indexPath.row].byId?.rawValue
        //        let currentUserId = Utils.fetchSavedUser()?.data.user.id
        //        print(currentUserId)
        //        print(currentCommentId)
        //        //if currentUserId == currentCommentId {
        //        if flag{
        //            flag = !flag;
        //            return UITableViewCell.EditingStyle.none
        //        }else{
        //            flag = !flag
        //            return false
        //        }
        return UITableViewCell.EditingStyle.none
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true;
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if (editingStyle == .delete) {
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //handle delete
            //self.view.makeToast("delete")
            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                self.commentDelete(comment: self.comments![indexPath.row], indexPath: indexPath, pos: indexPath.row)
            }))
            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            self.present(deleteConfirmation, animated: true) {}
        })
        deleteAction.image = UIImage(named: "delete_24")
        deleteAction.backgroundColor = .white
        
        
        let editAction = UIContextualAction(style: .normal, title:  "Edit", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            let cmt = self.comments![indexPath.row]
            self.alertWithTextField(title: Constants.APP_NAME, message: "Edit comment", placeholder: "Enter edit", text: cmt.commentData) { (comment) in
                print(comment)
                
                self.commentEdit(comment, cmt, indexPath.row)
            }
        })
        editAction.image = UIImage(named: "edit_24")
        editAction.backgroundColor = .white
        
        let currentCommentId = self.comments![indexPath.row].byId
        let currentUserId = Utils.fetchSavedUser().data.user.id
        print(currentUserId)
        print(currentCommentId)
        if currentUserId != currentCommentId {
            //if self.flag{
            //            flag = !flag;
            //            print(flag)
            return UISwipeActionsConfiguration(actions: [])
        }else{
            //            print(flag)
            //            flag = !flag
            return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
            
        }
    }
    
    //    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
    //        //let title = "\u{267A}\n"
    //        //let title = "Delete"
    //        var deleteAction = UITableViewRowAction(style: .default, title: "") {action,some  in
    //            //handle delete
    //            //self.view.makeToast("delete")
    //            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
    //            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
    //                  print("Handle Ok logic here")
    //                self.commentDelete(comment: self.comments![indexPath.row])
    //            }))
    //            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
    //                  print("Handle Cancel Logic here")
    //            }))
    //            self.present(deleteConfirmation, animated: true) {}
    //        }
    //        //deleteAction.backgroundColor = .clear
    ////        deleteAction.backgroundColor = UIColor(patternImage: UIImage(named: "delete_24")!)
    //        (UIButton.appearance(whenContainedInInstancesOf: [UIView.self])).setImage(UIImage(named: "ic_delete"), for: .normal)
    //
    //
    //        var editAction = UITableViewRowAction(style: .normal, title: "Edit" ) {action,some in
    //            //handle edit
    //            //self.view.makeToast("edit")
    //            let cmt = self.comments![indexPath.row]
    //            self.alertWithTextField(title: Constants.APP_NAME, message: "Edit comment", placeholder: "Enter edit", text: cmt.commentData) { (comment) in
    //                print(comment)
    //                self.commentEdit(comment: cmt)
    //            }
    //        }
    //        editAction.backgroundColor = .clear
    //
    //
    //        return [deleteAction, editAction]
    //    }
    
}

@available(iOS 13.0, *)
extension CommentsViewController: ProtocolCommentOptions{
    
    
    func onLblCommentClicked(comment: Comment?) {
        //lolo
        
//        let viewRoot = CustomAlert.instanceFromNib() as CustomAlert
//
//        viewRoot.lblSubject.text = comment?.commentData
//                   let malert = Malert(customView: viewRoot)
//                   let action = MalertAction(title: "Ok")
//                   action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
//                   malert.addAction(action)
//                   self.present(malert, animated: true) {}
//                   //            malert?.onDismissMalert {
//                   //                print("dismised")
//                   //                self.flag = false
//                   //            }
        
        
        
        let alert = UIAlertController(title: Constants.APP_NAME, message: comment?.commentData?.htmlToString, preferredStyle: .alert)
                          alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
              //            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                          self.present(alert, animated: true)
               
        
        
    }
    
    func onAttachClicked(comment: Comment?) {
        //self.view.makeToast((comment?.byFullName).map { $0.rawValue })
        
        let name = "Board"
        // let name = "Comments"
        let attachmentsVc = UIStoryboard(name: name, bundle: .main).instantiateViewController(identifier: "AttachmentsVCId") as AttachmentsViewController
        
        
        //        if self.attachment != nil {
        //            var attachments: [Attachment]? = []
        //            attachments?.append(self.attachment!)
        //            attachmentsVc.attachments = attachments!
        //            print("ofofof1")
        //        }else{
        //            print("ofofof2")
        //            attachmentsVc.attachments = comment?.attachments as! [Attachment]
        //        }
        attachmentsVc.attachments = comment?.attachments as! [Attachment]
        attachmentsVc.idBorTorC = comment?.commentId as! String
        attachmentsVc.typeBorTorC = "c"
        print(comment?.commentData)
        //        print(comment?.attachments![0])
        
        //self.present(attachmentsVc, animated: true) {}
        self.navigationController?.pushViewController(attachmentsVc, animated: true)
        
        
        
    }
    
    
    
    func onReplyClicked(comment: Comment?) {
        // self.view.makeToast((comment?.byFullName).map { $0.rawValue })
        
        
        UserDefaults.standard.setValue(true, forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI)
               let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
               let tabBarController = self.tabBarController!
               tabBar.tag = 0
              
        
        
        let name = "Board"
        // let name = "Comments"
        let replyVc = UIStoryboard(name: name, bundle: .main).instantiateViewController(identifier: "ReplyViewController") as ReplyViewController
        
        replyVc.comment = comment
        replyVc.idBorTorC = comment?.commentId as! String
        replyVc.typeBorTorC = "c"
        
        print(comment?.commentData)
        
        //self.present(replyVc, animated: true) {}
        self.navigationController?.pushViewController(replyVc, animated: true)
        
    }
    
}

@available(iOS 13.0, *)
extension CommentsViewController: ImagePickerDelegate{
    
    func cancelButtonDidPress(_ imagePicker: ImagePickerController) {
        if self.flagAttachPhoto {
            imagePicker.dismiss(animated: false, completion: nil)
            self.flagAttachPhoto = false
            
        }else{
            imagePicker.dismiss(animated: true, completion: nil)
        }
        
        
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
        
        let headers: HTTPHeaders = [
            .accept("application/jsonf"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .contentType("multipart/form-data"),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
//             .acceptLanguage("ar"),
            .init(name: "tz", value: TimeZone.current.identifier),

        ]
        let url = Constants.BASE_URL +  Constants.Uplaoding.END_POINT_UPLOAD_FILE
        upload(image: firestImage.pngData(), url: url, params: nil, headers: headers)
    }
}

@available(iOS 13.0, *)
extension CommentsViewController: ProtocolAddNewComment{
    
    func onPostComment() {
        print("on post comment")
        if (self.tvEnterComment?.text.isEmpty)! {
            self.view.makeToast("Enter comment data")
            return
        }
        self.addNewCommentMethod(comment: (self.tvEnterComment?.text)!)
    }
    
    func onImageAttachClicked() {
        print("on imv attach clicked")
        self.flagAttachPhoto = true;
        self.malert?.dismiss(animated: true, completion: {
            self.attachPhotoToComment()
        })
    }
    
}

@available(iOS 13.0, *)
extension CommentsViewController: OEMentionsDelegate{
    func onMensionCharDetected(detected: Bool?) {
        print(detected)
        if detected! {
            containerMentions.isHidden = false
            //tableViewPrevReplies.isHidden = true
        }else{
            containerMentions.isHidden = true
            //tableViewPrevReplies.isHidden = false
        }
    }
    
    
    func mentionSelected(user: UserAll?) {
        containerMentions.isHidden = true
        //tableViewPrevReplies.isHidden = false
    }
    
    
}
