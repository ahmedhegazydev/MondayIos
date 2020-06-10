//
//  InboxViewController.swift
//  ImageSlider
//
//  Created by A on 4/11/20.
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


@available(iOS 13.0, *)
class InboxViewController: UIViewController {
    
    var scrollTagsView: UIScrollView?
    var tagListView: TagListView?
    //    var tagListView: TaglistCollection?
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleOnRefreshMails), for: .valueChanged)
        
        return refresher
    }()
    var flagSentOrInbox: Bool = true
    var usersData = SearchableWrapper()
    var allUsers: [UserAll] {
        return self.usersData.dataArray as! [UserAll]
    }
    var flagReply = false
    var searchBarFilterUsers: UISearchBar?
    @IBOutlet weak var lblCounter: UILabel!
    @IBOutlet weak var lblTrash: UILabel!
    @IBOutlet weak var lblSend: UILabel!
    @IBOutlet weak var lblInbox: UILabel!
    @IBOutlet weak var cardInbox: CardView2!
    @IBOutlet weak var cardSend: CardView2!
    @IBOutlet weak var cardTrash: CardView2!
    @IBOutlet weak var ivAddEmail: UIImageView!
    var etEnterTitle: UITextField?
    var etEnterBody: UITextField?
    var malert: Malert?
    var tableViewUsers: UITableView?
    //    var mails: [Inbox] = [
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //        Inbox(title: "Ahmed", body: "Mohamed"),
    //    ]
    var mails: [InboxGetUser] = []
    var flag: Bool = false
    let cellReusableId = "CellMail2"
    let tableUserCellId = "CellUser"
    @IBOutlet weak var tableViewMails: UITableView!
    let headers: HTTPHeaders = [
        //.accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
         .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
         .init(name: "tz", value: TimeZone.current.identifier)
,
         
    ]
    //var allUsers: [String] = []
    var selectedUsers: [UserAll]? = []
    //var filteredUsers: [UserAll]? = []
    var users: String = ""
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initTables()
        //gettingInbox()
        //initFloatingActionButton()
        checkSavedUsers()
        
        self.ivAddEmail.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleAddNewEmail)))
        
        accessingTheTopSegmentedControl()
        
        
        
        //by default open the AllBoards Screen
        //        let index = 2
        //        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        //        let tabBarController = self.tabBarController!
        ////        tabBar.tag = 0 //for receiving after viewdidload        self.tabBarController!.selectedIndex = index
        //        self.tabBarController!.selectedViewController = tabBarController.viewControllers![index]
        
        
        
        
        
    }
    
    func accessingTheTopSegmentedControl(){
        
        cardSend.isUserInteractionEnabled = true;
        cardInbox.isUserInteractionEnabled = true;
        cardTrash.isUserInteractionEnabled = true;
        
        cardSend.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCardSendClick)))
        cardInbox.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCardInboxClick)))
        cardTrash.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleCardTrashClick)))
        
        
        //default
        handleCardInboxClick()
    }
    
    
    @objc func handleOnRefreshMails(){
        print("refreshing....")
        
        //        let deadLine = DispatchTime.now() + .microseconds(500)
        //        DispatchQueue.main.asyncAfter(deadline: deadLine) {
        //            self.refresher.endRefreshing()
        //        }
        
        
        if flagSentOrInbox {
            //mail
            gettingInbox()
            
        }else{
            //sent
            gettingMailSent()
            
            
        }
        
    }
    
    @objc func handleCardSendClick(){
        cardTrash.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        cardInbox.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        cardSend.backgroundColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        
        // label bg color
        lblSend.backgroundColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        lblInbox.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        lblTrash.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        
        //label text color
        lblSend.textColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        lblInbox.textColor = .black
        lblTrash.textColor = .black
        
        //        cardSend.shadowOpacity = 1
        //        cardInbox.shadowOpacity = 0
        
        lblCounter.isHidden = true;
        self.flagSentOrInbox = false
        enableCards(enable: false)
        gettingMailSent()
        
    }
    
    @objc func handleCardInboxClick(){
        
        cardTrash.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        cardSend.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        cardInbox.backgroundColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        
        
        //label
        lblInbox.backgroundColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        lblInbox.textColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        
        lblCounter.isHidden = false;
        lblSend.backgroundColor = .white
        lblSend.textColor = .black
        
        lblTrash.backgroundColor = .white
        lblTrash.textColor = .black
        
        //        cardSend.shadowOpacity = 0
        //        cardInbox.shadowOpacity = 1
        
        enableCards(enable: false)
        self.flagSentOrInbox = true;
        gettingInbox()
    }
    
    @objc func handleCardTrashClick(){
        
        //        cardInbox.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        //        cardSend.backgroundColor = Utils.hexStringToUIColor(hex: "#FFFFFF")
        //        cardTrash.backgroundColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        //
        //
        //        lblTrash.backgroundColor  = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        //        lblTrash.textColor = .white
        //        lblInbox.backgroundColor = .white
        //        lblInbox.textColor = .black
        //        lblCounter.isHidden  = true
        //        lblSend.backgroundColor = .white
        //        lblSend.textColor = .black
        
    }
    
    
    @objc func handleAddNewEmail(){
        flagReply = false
        self.showPopAlertEnterEmailInfoViewController()
    }
    
    func checkSavedUsers(){
        //        if let data = UserDefaults.standard.value(forKey:Constants.SAVED_ALL_USERS) as? Data {
        //            let users = try? PropertyListDecoder().decode(Array<UserAll>.self, from: data)
        //            //self.view.makeToast("exist")
        //            print("gogo exist")
        //            self.usersData.serverArray = users!
        //        }else{
        //            getAllUsers()
        //            //self.view.makeToast("downloading")
        //            print("gogo downloading")
        //        }
        
        getAllUsers()
        
    }
    
    func initTables(){
        
        if flag {
            //            self.tableViewUsers?.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
            self.tableViewUsers?.register(UINib(nibName: tableUserCellId, bundle: .main), forCellReuseIdentifier: tableUserCellId)
            tableViewUsers!.delegate = self;
            tableViewUsers!.dataSource = self;
            tableViewUsers!.reloadData()
        }else{
            self.tableViewMails.register(UINib(nibName: self.cellReusableId, bundle: .main
            ), forCellReuseIdentifier: cellReusableId)
            tableViewMails.delegate = self;
            tableViewMails.dataSource = self;
            tableViewMails.reloadData()
            tableViewMails.separatorStyle = .none
            tableViewMails.allowsSelection = false
            tableViewMails.refreshControl = self.refresher
            
            
        }
    }
    
    func getAllUsers(){
        //self.view.makeToastActivity(.center)
        var url = Constants.BASE_URL + Constants.Ends.END_POINT_GET_ALL_USERS
        debugPrint(url)
        url = Constants.BASE_URL + "user/allusers"
        AF.request(url,method: .get,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                //self.view.hideToastActivity()
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
                            let allUsersData = try decoder.decode(UserDataAll.self, from: data)
                            //self.allUsers = allUsersData.data!
                            self.usersData.serverArray = allUsersData.data!
                            
                            //self.view.makeToast("\(self.allUsers!.count)")
                            //self.tableViewUsers?.reloadData()
                            
                            //                            UserDefaults.standard.set(self.allUsers, forKey : Constants.SAVED_ALL_USERS)
                            
                            
                            UserDefaults.standard.set(try? PropertyListEncoder().encode(self.allUsers), forKey: Constants.SAVED_ALL_USERS)
                            //
                            //                            let encoded = NSKeyedArchiver.archivedData(withRootObject: self.allUsers)
                            //                            UserDefaults.standard.set(encoded, forKey: Constants.SAVED_ALL_USERS)
                            
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
    
    func initFloatingActionButton(){
        
        let actionButton = DTZFloatingActionButton()
        actionButton.tintColor = Utils.hexStringToUIColor(hex: "#189276")
        actionButton.handler = {
            button in
            self.showPopAlertEnterEmailInfoViewController()
        }
        actionButton.isScrollView = true
        self.view.addSubview(actionButton)
    }
    
    
    func showPopAlertEnterEmailInfoViewController(){
        //            let enterEmailInfo = UIStoryboard(name: "AddEmailInfo", bundle: .main).instantiateViewController(withIdentifier: "AddEmailInfoVc") as! AddEmailInfoVc
        //            //let enterEmailInfo = AddEmailInfoVc()
        //            enterEmailInfo.modalPresentationStyle = .overCurrentContext
        //            enterEmailInfo.modalTransitionStyle = .crossDissolve
        //            self.present(enterEmailInfo, animated: true) {}
        
        
        
        let viewRoot: UIView?
        print(" XXXXX sd gogo")
        if flagReply {
            let view  = AddEmailInfoReplyView.instanceFromNib() as AddEmailInfoReplyView
            viewRoot = view
            view.delegate = self;
            
            self.etEnterTitle  = view.etEnterTitle
            self.etEnterBody = view.etEnterBody
            self.etEnterTitle?.delegate = self
            self.etEnterBody?.delegate = self;
            
            
            malert = Malert(customView: viewRoot)
            //            let action = MalertAction(title: "Back")
            //            action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
            //            malert!.addAction(action)
            self.present(malert!, animated: true) {}
            //            malert?.onDismissMalert {
            //                print("dismised")
            //                self.flag = false
            //            }
        }else{
            let view  = AddEmailInfoView.instanceFromNib() as AddEmailInfoView
            viewRoot = view
            if let data = UserDefaults.standard.value(forKey: Constants.SAVED_ALL_USERS) as? Data {
                let users = try? PropertyListDecoder().decode(Array<UserAll>.self, from: data)
                self.usersData.serverArray = users!
                self.tableViewUsers = view.tableViewUsers;
                
                self.flag = true;
                //self.tableViewUsers!.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
                self.tableViewUsers?.register(UINib(nibName: tableUserCellId, bundle: .main), forCellReuseIdentifier: tableUserCellId)
                self.tableViewUsers!.delegate = self;
                self.tableViewUsers!.dataSource = self;
                view.delegate = self;
                
                self.etEnterTitle = view.etEnterTitle
                self.etEnterBody = view.etEnterBody
                self.etEnterTitle?.delegate = self
                self.etEnterBody?.delegate = self;
                
                self.scrollTagsView = view.scrollTagsView
                self.accessTagListView(view.tagsListView)
                
                
                //self.filteredUsers = users
                self.searchBarFilterUsers = view.searchBar
                self.searchBarFilterUsers!.delegate = self.usersData
                //self.tableViewUsers!.tableHeaderView = self.searchBarFilterUsers
                self.usersData.searchingCallBack = { isSearching, searchText in
                    print("searching Text:= \(searchText)")
                    self.tableViewUsers!.reloadData()
                    if searchText.isEmpty {
                        view.containerUserAndTags?.isHidden = false
                        view.tableViewUsers.isHidden = true;
                        view.tagsListView.isHidden = false
                        view.scrollTagsView.isHidden = false
                        let animation = AnimationType.zoom(scale: 0.0)
                        self.tableViewUsers!.animate(animations: [animation])
                    }else{
                        view.tableViewUsers.isHidden = false;
                        view.tagsListView.isHidden = true
                        view.scrollTagsView.isHidden = true
                        
                        view.containerUserAndTags.isHidden = false
                        let animation = AnimationType.zoom(scale: 0.5)
                        self.tableViewUsers!.animate(animations: [animation])
                        
                    }
                }
                self.usersData.serverArray = users!
                self.tableViewUsers!.reloadData()
            }
            
            malert = Malert(customView: viewRoot)
            //            let action = MalertAction(title: "Back")
            //            action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
            //            malert!.addAction(action)
            self.present(malert!, animated: true) {}
            malert?.onDismissMalert {
                print("dododo dismised")
                self.flag = false
                self.selectedUsers = []//for clearing all selected users in tags
                self.tableViewMails!.reloadData()

            }
            
        }
        
        
        
    }
    
    func accessTagListView(_ tagLv: TagListView){
        tagLv.delegate = self
        //        tagLv.addTag("TagListView")
        //        tagLv.addTag("TEAChart")
        //        tagLv.addTag("To Be Removed")
        //        tagLv!.addTag("To Be Removed")
        //        tagLv!.addTag("Quark Shell")
        //        tagLv!.removeTag("To Be Removed")
        //        tagLv!.addTag("On tap will be removed").onTap = { [weak self] tagView in
        //                self?.tagListView!.removeTagView(tagView)
        //            }
        //
        //        let tagView = tagLv!.addTag("gray")
        //        tagView.tagBackgroundColor = UIColor.gray
        //        tagView.onTap = { tagView in
        //                print("Don’t tap me!")
        //            }
        //
        //        tagLv!.insertTag("This should be the third tag", at: 2)
        
        
        self.tagListView = tagLv
    }
    
    func enableCards(enable: Bool?){
        self.cardInbox.isUserInteractionEnabled = enable!
        self.cardSend.isUserInteractionEnabled = enable!
    }
    
    func gettingInbox(){
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Inbox.END_GET_MAIL
        debugPrint(url)
        AF.request(url,method: .get,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                self.view.hideToastActivity()
                self.enableCards(enable: true)
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: get all mails \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let decoder = JSONDecoder()
                            let getUserData = try decoder.decode(InboxGetUserData.self, from: data)
                            self.mails = getUserData.data
                            self.flag = false;
                            self.initTables()
                            
                            
                            
                            //getting the counter top seen or not
                            var counterNoSeen: Int = 0
                            for n in 0..<self.mails.count {
                                if !self.mails[n].isSeen {
                                    counterNoSeen  = counterNoSeen + 1;
                                }
                            }
                            self.lblCounter.text = " \(counterNoSeen)"
                            
                            
                            self.refresher.endRefreshing()
                            
                            
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
    
    
    func gettingMailSent(){
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Inbox.END_GET_MAIL_SENT
        debugPrint(url)
        AF.request(url,method: .get,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                self.view.hideToastActivity()
                self.enableCards(enable: true)
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: get main sent \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let decoder = JSONDecoder()
                            let getUserData = try decoder.decode(InboxGetUserData.self, from: data)
                            self.mails = getUserData.data
                            self.flag = false;
                            self.initTables()
                            
                            
                            self.refresher.endRefreshing()
                            
                            
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
    
    func postMail(view: UIView, inbox: Inbox){
        
        
        
        print("gogoGG")
        
        var title: String = ""
        var body: String = ""
        var attachName: String = ""
        
        
        title = "\(inbox.title)"
        body = "\(inbox.body)"
        attachName = ""
        if flagReply {
            users = "\(self.users)"
            print("all_users1  = \(users)")
        }else{
            users = "\(inbox.users)"
            print("all_users2 = \(users)")
            
        }
        users = users.trimmingCharacters(in: .whitespacesAndNewlines)
        
        print(title)
        print(body)
        print(attachName)
        print("users  = \(users)")
        
        
        let parameters: [String: Any] = [
            "title": "\(title)",
            "body" : "\(body)",
            "attachName" : "\(attachName)",
            "users" : "\(users)",
        ]
        
        view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Inbox.END_POST_MAIL
        debugPrint(url)
        AF.request(url,method: .post, parameters: parameters, 
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: post new email \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            self.malert?.dismiss(animated: true, completion: {})
                            //self.view.makeToast("Post sent success")
                            //self.getAllMails()
                            //self.refreshTableViewMails()
                            self.flag = false
                            self.selectedUsers = []
                            self.tableViewMails.reloadData()
                            
                            
                            
                        } catch let error {
                            print(error)
                        }
                    }else{
                        let errorMessage: String =  swiftyData["errorMessages"][0].stringValue
                        debugPrint("error \(errorMessage)")
                        UtilsAlert.showError(message: errorMessage)
                        //                        self.view.hideToastActivity()
                        view.hideAllToasts()
                        //                        self.view.hideAllToasts(includeActivity: true, clearQueue: true)
                        
                    }
                case .failure(let error):
                    debugPrint( "Failure: \(error.localizedDescription)")
                    UtilsAlert.showError(message: "Network connection error")
                    view.hideToastActivity()
                    
                }
        }
    }
    
    func setMailAsSeen(mail: InboxGetUser){
        self.view.makeToastActivity(.center)
        let url = Constants.BASE_URL + Constants.Inbox.END_PUT_MAIL + mail.id
        debugPrint(url)
        AF.request(url,method: .put,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: mail set as seen \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            //Loaf("Email set as seen", state: .success, sender: self).show()
                            
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
    
}


@available(iOS 13.0, *)
extension InboxViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if flag {
            return self.allUsers.count
            //return self.filteredUsers!.count
        }else{
            return self.mails.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell?
        
        if flag {
            //            cell = self.tableViewUsers!.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! UITableViewCell
            cell = self.tableViewUsers?.dequeueReusableCell(withIdentifier: tableUserCellId, for: indexPath) as! CellUser
            let cellUser = cell as! CellUser
            
            let user = self.allUsers[indexPath.row]
            
            print(user.email)
            //cell?.textLabel?.text = user.userName
            //cell?.textLabel?.text = user.email
            //            cellUser.lblUserName.text = user.email
            cellUser.lblUserName.text = user.fullName
            if (!user.userImage!.isEmpty && (user.userImage!.starts(with: "http") || user.userImage!.starts(with: "https"))) {
                let url = URL(string: user.userImage!)
                cellUser.ivUserPhoto.kf.setImage(with: url)
            }else{
                // Circle avatar image with white border
                cellUser.ivUserPhoto.image = Utils.letterAvatarImage(chars: user.shortName!)
            }
            
            
            
        }else{
            //            cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellMail
            //            let emailCell = cell as! CellMail
            
            cell = tableView.dequeueReusableCell(withIdentifier: self.cellReusableId, for: indexPath) as! CellMail2
            let emailCell = cell as! CellMail2
            
            
            
            let mail = self.mails[indexPath.row]
            
            
            
            emailCell.lblComment.text = mail.body.htmlToString
            //            emailCell.lblComment.text = "If you aren’t using styled text, this property applies to the entire text string in the text property. If you’re using styled text, assigning a new value to this property applies the line break mode to the entirety of the string in the attributedText property. To apply the line break"
            emailCell.ivShowAttachments.isHidden = true;
            emailCell.lblDate.text = Utils.pureDateTime(dateBefore: mail.createdAt)
            if flagSentOrInbox {
                //inbox
                emailCell.ivReply.isHidden = false;
                print("userimage fofo = \(mail.fromUser.userImage)")
                print("userimage fofo = \(mail.fromUser.shortName)")
                if (!mail.fromUser.userImage.isEmpty && (mail.fromUser.userImage
                    .starts(with: "http") ||
                    mail.fromUser.userImage
                        .starts(with: "https"))) {
                    let url = URL(string: mail.fromUser.userImage)
                    emailCell.ivUserImage.kf.setImage(with: url)
                    
                }else{
                    emailCell.ivUserImage.image = Utils.letterAvatarImage(chars: mail.fromUser.shortName)
                }
                
                emailCell.lblUserName.text = mail.fromUser.name
            }else{
                
                //send
                emailCell.ivIsSeen.isHidden = true
                emailCell.ivReply.isHidden = true;
                
                
                var str: String = ""
                for n in 0..<mail.toUsers.count{
                    if n == mail.toUsers.count - 1{
                        str = str + mail.toUsers[n].name
                    }else{
                        str = str + mail.toUsers[n].name + ","
                    }
                }
                print("sosossoe  =  \(str)")
                emailCell.lblUserName.text = str
                
                
            }
            
            if mail.isSeen{
                //emailCell.backgroundColor = .lightGray
                emailCell.ivIsSeen.isHidden = true;
                
            }else{
                
                //emailCell.backgroundColor  = .white
                emailCell.ivIsSeen.isHidden = false;
            }
            
            emailCell.setMail(mail: mail)
            emailCell.delegate = self;
        }
        
        
        return cell!;
    }
}


@available(iOS 13.0, *)
extension InboxViewController: ProtocolInboxSection{
    
    
    func onLblMakeInboxAsSeenClicked(mail: InboxGetUser?, users: String) {
        print("lbl clicked")
        if flag {
            
        }else{
            setMailAsSeen(mail: mail!)
            //UtilsAlert.showInfo(message: mail.body)
            //UtilsAlert.showInfo2(self, Constants.APP_NAME, mail?.body)
            
            //let viewRoot = CustomAlert.instanceFromNib() as CustomAlert
//            let viewRoot  = CustomAlert(frame: CGRect(x: 0, y: 0, width: 200, height: 400))

//            viewRoot.lblSubject.text = users  + "\n" + (mail?.body.htmlToString)!
//            let malert = Malert(customView: viewRoot)
//            let action = MalertAction(title: "Ok")
//            action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
//            malert.addAction(action)
//            self.present(malert, animated: true) {}
            //            malert?.onDismissMalert {
            //                print("dismised")
            //                self.flag = false
            //            }
            
//            let myCustomViewController = UIStoryboard(name: "Board", bundle: .main).instantiateViewController(identifier: "ScrollLableCv") as ScrollLabelViewController
//            myCustomViewController.modalPresentationStyle = .overCurrentContext
//            myCustomViewController.view.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)

//            let alert : UIAlertController =  UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//            alert.setValue(myCustomViewController, forKey: "contentViewController")
//            self.present(alert, animated: true)
//
            
            
            let alert = UIAlertController(title: Constants.APP_NAME, message: users  + "\n" + (mail?.body.htmlToString)!, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yes", style: .default, handler: nil))
//            alert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
            self.present(alert, animated: true)
            
        }
    }
    
    
    func onReplyClicked(mail: InboxGetUser?) {
        print(mail?.body)
        print(mail?.toUsers)
        users = ""
        //var users: String = ""
        for n in 0..<(mail?.toUsers.count)! {
            if n == (mail?.toUsers.count)! - 1 {
                users = users + (mail?.toUsers[n].id)!
            }else{
                users = users + (mail?.toUsers[n].id)! + ","
            }
        }
        print(users)
        flagReply = true
        // self.users = mail.user
        showPopAlertEnterEmailInfoViewController()
        
    }
}


@available(iOS 13.0, *)
extension InboxViewController: UITableViewDelegate{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if flag {
            return 80;
        }else{
            return 250;
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return CGFloat(0)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //self.view.makeToast("\(indexPath.row)")
        if flag {
            //tableview users
            let selectedUser = self.allUsers[indexPath.row]
            print(selectedUser.userName)
            print(selectedUser.email)
            self.tableViewUsers?.isHidden = true
            self.tagListView?.isHidden = false;
            self.scrollTagsView?.isHidden = false;
            
            var exist: Bool = false;
            for n in 0..<self.selectedUsers!.count {
                if selectedUser.email == self.selectedUsers![n].email {
                    //exist
                    exist = true;
                }else{
                    exist = false
                }
            }
            if exist {
                
            }else{
                self.selectedUsers?.append(selectedUser)
                self.tagListView?.addTag(selectedUser.email!)
                //saving
                UserDefaults.standard.set(try? PropertyListEncoder().encode(self.selectedUsers), forKey: Constants.INBOX_SELECTED_RECIPIENTS)
            }
            
        }else{
            //let mail = self.mails[indexPath.row]
            //setMailAsSeen(mail: mail)
            //UtilsAlert.showInfo(message: mail.body)
        }
    }
    
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if flag {
            return  false
        }else{
            return false;
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        //        if (editingStyle == .delete) {
        //            // handle delete (by removing the data from your array and updating the tableview)
        //        }
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .normal, title:  "Delete", handler: { (ac:UIContextualAction, view:UIView, success:(Bool) -> Void) in
            //handle delete
            //self.view.makeToast("delete")
            let deleteConfirmation = UIAlertController(title: "Are u sure?", message: "All data will be lost.", preferredStyle: UIAlertController.Style.alert)
            deleteConfirmation.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action: UIAlertAction!) in
                print("Handle Ok logic here")
                //                self.attachDelete(attach: self.attachments![indexPath.row])
                
            }))
            deleteConfirmation.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                print("Handle Cancel Logic here")
            }))
            self.present(deleteConfirmation, animated: true) {}
        })
        deleteAction.image = UIImage(named: "delete_24")
        deleteAction.backgroundColor = .white
        
        
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

@available(iOS 13.0, *)
extension InboxViewController: ProtocolPostNewEmail{
    
    
    func onBtnCloseClicked() {
        self.malert?.dismiss(animated: true, completion: {
            
        })
    }
    
    
    func onPostBtnClicked(view: UIView, inbox: Inbox?) {
        let users =  getAllSelectedUsersToSend()
        let ids = users?.joined(separator: ",")
        print(inbox?.title)
        print(inbox?.body)
        print(ids)
        var msg: String = ""
        
        
        //        if users!.isEmpty {
        //            msg = "Select one recipient as minimum"
        ////            self.view.makeToast(msg)
        //            return
        //        }
        
        //        if (inbox?.title.isEmpty)!{
        //            msg = "Enter title"
        //            self.view.makeToast(msg)
        //            return
        //        }
        
        //        if (inbox?.body.isEmpty)!{
        //            msg  = "Enter body"
        //            self.view.makeToast("Enter body")
        //            return
        //        }
        
        let inbo = Inbox(title: inbox!.title,
                         body: inbox!.body,
                         userIds: ids!)
        postMail(view: view, inbox: inbo)
        
    }
    
    func getAllSelectedUsersToSend() -> [String]?{
        var arr: [String]? = []
        //        guard let indexPaths = self.tableViewUsers?.indexPathsForSelectedRows else { // if no selected cells just return
        //            return []
        //        }
        //        for indexPath in indexPaths {
        //            print(self.allUsers[indexPath.row].email)
        //            arr?.append(self.allUsers[indexPath.row].id!)
        //        }
        
        for n in 0..<self.selectedUsers!.count {
            arr?.append(self.selectedUsers![n].id!)
        }
        
        return arr
    }
    
}


@available(iOS 13.0, *)
extension InboxViewController: UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        print(searchText)
        //self.tableViewUsers?.isHidden = searchText.isEmpty
        
        
    }
    
    
}

@available(iOS 13.0, *)
extension InboxViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("hoho")
        
        if textField.isEqual(self.etEnterTitle) {
            self.etEnterTitle!.resignFirstResponder()
            self.etEnterBody?.becomeFirstResponder()
        }
        if textField.isEqual(self.etEnterBody) {
            //self.view.endEditing(true)
            textField.resignFirstResponder()
        }
        
        return true;
    }
    
}


@available(iOS 13.0, *)
extension InboxViewController: TagListViewDelegate{
    
    // MARK: TagListViewDelegate
    func tagPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag pressed: \(title), \(sender)")
        tagView.isSelected = !tagView.isSelected
        
    }
    
    func tagRemoveButtonPressed(_ title: String, tagView: TagView, sender: TagListView) {
        print("Tag Remove pressed: \(title), \(sender)")
        sender.removeTagView(tagView)
        for n in 0..<self.selectedUsers!.count {
            if title == self.selectedUsers![n].email {
                self.selectedUsers?.remove(at: n)
                break
            }
        }
        for n in 0..<self.selectedUsers!.count {
            print("hoho  = \(self.selectedUsers![n].email)")
        }
        
        //saving
        UserDefaults.standard.set(try? PropertyListEncoder().encode(self.selectedUsers), forKey: Constants.INBOX_SELECTED_RECIPIENTS)
        
        
    }
}
