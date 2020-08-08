//
//  NestedViewController.swift
//  ImageSlider
//
//  Created by A on 4/5/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//
import UIKit
import SwiftyJSON
import Alamofire
import MaterialActivityIndicator
import YNExpandableCell
import LUExpandableTableView
import RestEssentials
//import WJXOverlappedImagesView
import Kingfisher
import SDWebImage
import LetterAvatarKit
import SSCustomTabbar
import Malert


@available(iOS 13.0, *)
class NestedViewController2: UIViewController {
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleOnRefresh), for: .valueChanged)
        return refresher
        
    }()
    var fromAllBoardsNotNotifi: Bool = false;
    let cellIdLetterAvatar = "CellLetterAvatar"
    var shortNames: [String] = []
    var team: Team? = nil
    var  groups : [TasksGroup] = []
    var tasksDic: [Int: [TaskH]] = [:]
    var boardId: String = ""
    var base : NestedBoardH?
    var users: [UserHere] = []
    var task: TaskH?
    fileprivate let tasks: [TaskH] = []
    private var indicator = MaterialActivityIndicatorView()
    @IBOutlet weak var collectionLetrreAvatars: UICollectionView!
    //    @IBOutlet weak var overlappedImagesView: WJXOverlappedImagesView!
    var images: [String] = []
    var malertShowAllUsers: Malert?
    var tableViewAllUsers: UITableView?
    var flag: Bool = true;
    
    //private let expandableTableView = LUExpandableTableView()
    //    @IBOutlet weak var expandableTableView: LUExpandableTableView!
    @IBOutlet weak var expandableTableView: UITableView!
    
    //    private let cellReuseIdentifier = "GroupTaskCell"
    private let cellReuseIdentifier = "GroupTaskCell2"
    private let sectionHeaderReuseIdentifier = "GroupSectionHeader2"
    private lazy var imageUrls =  [
        "https://avatars1.githubusercontent.com/u/4176744?v=40&s=132",
        "https://avatars1.githubusercontent.com/u/565251?v=3&s=132",
        "https://avatars2.githubusercontent.com/u/587874?v=3&s=132",
        "https://avatars2.githubusercontent.com/u/1019875?v=4&s=132",
        "https://avatars2.githubusercontent.com/u/839283?v=4&s=132",
        "https://avatars0.githubusercontent.com/u/724423?v=3&s=132",
        "https://avatars3.githubusercontent.com/u/602569?v=4&s=132",
        "https://avatars1.githubusercontent.com/u/8086633?v=3&s=132",
    ]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupExpandableTableView()
        
        
        print("Nested VC \(self.boardId)")
        getNested()
        
        //setting an empty array firstlty
        //        accessOverlappingImagesView(overlappedImagesView: self.overlappedImagesView, images: self.images)
        
        
        initCollectionLetterAvatars(sectionHeader: nil)
        print("kkee \(self.shortNames.count)")
        
        
        
        
        let addImage = UIImage(systemName: "plus")
        let addBarButtonItem = UIBarButtonItem(image: addImage, style: .done, target: self, action: #selector(postNewTaskToBoardGroup))
        self.navigationItem.rightBarButtonItems  = [addBarButtonItem]
        
        
    }
    
    
    @objc func postNewTaskToBoardGroup(){
        
        if let base = self.base {
            let name = "Board"
               let commentsVc = UIStoryboard(name: name, bundle: .main)
                   .instantiateViewController(withIdentifier:
                       "PostNewTaskVc") as! PostNewTaskToBoardVC
               commentsVc.modalPresentationStyle = .formSheet
               commentsVc.modalTransitionStyle = .coverVertical
               commentsVc.users = self.users
               commentsVc.tasksGroupId = base.tasksGroup![0].id as! String
               self.navigationController?.pushViewController(commentsVc, animated: true)
        }
        
           
        
    }
    
    
    
    override func viewDidAppear(_ animated: Bool) {
        //        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        //        if tabBar.tag == 2{
        ////            dismiss(animated: false) {}
        //        }
        //
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        indicator.stopAnimating()
        
        
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        if tabBar.tag == 2 && !UserDefaults.standard.bool(forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI){
            //                    dismiss(animated: false) {}
            let movetoroot = true;
            if movetoroot {
                navigationController?.popToRootViewController(animated: true)
            } else {
                navigationController?.popViewController(animated: true)
            }
            tabBar.tag  = 0
        }else{
        }
    }
    
    
    
    
    func initCollectionLetterAvatars(sectionHeader: GroupSectionHeader2?){
        
        
        //if you use xibs:
        self.collectionLetrreAvatars.register(UINib(nibName: "CellLetterAvatar", bundle: .main), forCellWithReuseIdentifier: self.cellIdLetterAvatar)
        //or if you use class:
        //         sectionHeader?.collectionLetrreAvatars.register(CellLetterAvatar.self, forCellWithReuseIdentifier: cellIdentifier)
        
        
        self.collectionLetrreAvatars.delegate = self
        self.collectionLetrreAvatars.dataSource = self
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //        expandableTableView.frame = view.bounds
        //    expandableTableView.frame.origin.y += 20
    }
    
    
    
    func setupExpandableTableView(){
        let padding = CGFloat(20)
        //expandableTableView.contentInset = UIEdgeInsets(top: 0, left: padding, bottom: padding, right: padding)
        
        
        //        view.addSubview(expandableTableView)
        
        //        self.expandableTableView.register(GroupTaskCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        
        self.expandableTableView.register(UINib(nibName: cellReuseIdentifier, bundle: nil),  forCellReuseIdentifier: cellReuseIdentifier)
        
        self.expandableTableView.register(UINib(nibName: sectionHeaderReuseIdentifier, bundle: .main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        
        expandableTableView.refreshControl = refresher
        expandableTableView.delegate = self
        expandableTableView.dataSource = self
        
        
    }
    
    @objc func handleOnRefresh(){
        print("refreshing....")
        
        //           let deadline = DispatchTime.now() + .milliseconds(400)
        //           DispatchQueue.main.asyncAfter(deadline: deadline) {
        //               self.refresher.endRefreshing()
        //           }
        
        
        
        getNested()
    }
    
    func getNested(){
        //self.view.makeToastActivity(.center)
        //indicator.startAnimating()
        self.showLoading()
        
        let headers: HTTPHeaders = [
            //.accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
            .init(name: "tz", value: TimeZone.current.identifier)
            ,
            
        ]
        let id = "?id=\(self.boardId)"
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_NESTED + id
        debugPrint("fofo = \(url)")
        AF.request(url,method: .get,
                   //encoding: JSONEncoding.default,
            headers: headers)
            .response { response in
                //.responseJSON { response in
                //debugPrint("resp \(response)")
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: \(response.value)")
                    self.stopLoading()
                    
                    let swiftyData = JSON(response.value as Any)
                    let successful = swiftyData["successful"].intValue
                    //debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        //debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let boardData = try decoder.decode(Nested.self, from: data)
                            
                            //fetching nested board
                            self.base = boardData.data?.BoardData?.nestedBoard![0]

                            
                            //saving the nested board
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(self.base) {
                                let defaults = UserDefaults.standard
                                defaults.set(encoded, forKey: Constants.SELECTED_NESTED_BOARD)
                            }
                            
                            for n in 0..<(self.base?.users?.count)!{
                                let user =  self.base?.users![n]
                                print("user number \(n) name  = \(user?.fullName)")
                            }
                            
                            
                            
                            self.accessFields()
                            
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
                    self.stopLoading()
                    UtilsAlert.showError(message: "Network connection error")
                    
                }
                
                
        }
        
    }
    
    func accessFields(){
        
        //settting the title
        self.title = base?.name
        //self.view.makeToast(base?.name)
        
        //groups
        self.groups  = self.base!.tasksGroup!
        
        //fetching tasks
        for n in 0...self.groups.count - 1 {
            let tasks = self.groups[n].tasks
            self.tasksDic[n] = tasks
        }
        
        //users
        self.users = self.base!.users!
        //print("Gogo \(self.users.count)")
        
        //team
        self.team = self.base?.team
        
        //set the user imags paths/letters
        //self.fillUserImages()
        
        //refresh
        self.expandableTableView.reloadData()
        self.collectionLetrreAvatars.reloadData()
    }
    
    func fillUserImages(){
        print("Gogo \(self.users.count)")
        for n in 0..<self.users.count {
            let user = users[n]
            let image = user.userImage
            let shortName = user.shortName
            if image!.starts(with: "http://") || image!.starts(with: "https://") {
                images.append(image!)
                print("Gogo \(image)")
            }else{
                self.shortNames.append(shortName!)
                print(shortName)
            }
        }
        
        if images.isEmpty {
            //sol1 temp array
            //images = self.imageUrls
            //sol2 letter avatar
            //self.collectionLetrreAvatars.isHidden = false
            //self.overlappedImagesView.isHidden = true
            
            print(" isEmpty kkee \(self.shortNames.count)")
            self.collectionLetrreAvatars.reloadData()
            
        }else{
            //            self.collectionLetrreAvatars.isHidden = true
            //            self.overlappedImagesView.isHidden = false
            //            accessOverlappingImagesView(overlappedImagesView: self.overlappedImagesView, images: self.images)
        }
    }
    
    
    func showPopUpAllUsersViewController(){
        
        let view = NestedShowAllUsers.instanceFromNib() as NestedShowAllUsers
        
        
        self.tableViewAllUsers = view.tableViewUsers;
        self.flag = false;
        self.tableViewAllUsers!.register(UINib(nibName: "CellUser", bundle: nil), forCellReuseIdentifier: "CellUser")
        self.tableViewAllUsers!.delegate = self
        self.tableViewAllUsers!.dataSource = self
        self.tableViewAllUsers!.reloadData()
        
        
        malertShowAllUsers = Malert(customView: view)
        let action = MalertAction(title: "Back")
        action.tintColor = UIColor(red:0.15, green:0.64, blue:0.85, alpha:1.0)
        malertShowAllUsers!.addAction(action)
        self.present(malertShowAllUsers!, animated: true) {}
        malertShowAllUsers?.onDismissMalert {
            print("dismised")
            self.flag = true
        }
        
        
        
        
    }
    
    
    func stopLoading(){
        //self.indicator.stopAnimating()
        self.view.hideToastActivity()
    }
    
    func showLoading(){
        self.view.makeToastActivity(.center)
        //        indicator.startAnimating()
    }
    
    func openLinkAlertAction(link: String) {
        
        
        
        let alertControllerLang = UIAlertController(title: Constants.APP_NAME, message: "Do u want to browse link?", preferredStyle: .alert)
        
        let arabic = UIAlertAction(title: "Yes", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            
            if link.starts(with: "http") || link.starts(with: "https"){
                guard let url = URL(string: link) else { return }
                UIApplication.shared.open(url)
            }
            
            
        })
        
        let english = UIAlertAction(title: "No", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            
            alertControllerLang.dismiss(animated: true) {
                
            }
            
        })
        
        alertControllerLang.addAction(arabic)
        alertControllerLang.addAction(english)
        
        self.present(alertControllerLang, animated: true, completion: nil)
        
    }
    
}

@available(iOS 13.0, *)
extension NestedViewController2: DelegateAttachGroupSection{
    
    
    func onShowllUsersClicked(task: TasksGroup?) {
        self.flag = false
        self.users = self.base?.users as! [UserHere]
        self.showPopUpAllUsersViewController()
    }
    
    func onGroupSecAttachClicked(task: TasksGroup?) {
        
        
        UserDefaults.standard.setValue(true, forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI)
        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        let tabBarController = self.tabBarController!
        tabBar.tag = 0
        
        
        
        //self.view.makeToast("Attach cleicked")
        print("Attch clicked")
        
        let name = "Board"
        // let name = "Comments"
        let attachmentsVc = UIStoryboard(name: name, bundle: .main).instantiateViewController(identifier: "AttachmentsVCId") as AttachmentsViewController
        //attachmentsVc.nestedBoard = base
        
        //        attachmentsVc.attachments = base?.attachmentsGeneral as! [Attachment]
        //        for n in 0..<attachmentsVc.attachments.count {
        //            if attachmentsVc.attachments[n].isDelete == nil {
        //                attachmentsVc.attachments[n].isDelete = false
        //            }else{
        //                attachmentsVc.attachments[n].isDelete = true;
        //            }
        //        }
        
        
        if let data = UserDefaults.standard.value(forKey: Constants.SAVED_ATTACHMENTS_TO_NESTED) as? Data {
            let attachments = try? PropertyListDecoder().decode(Array<Attachment>.self,
                                                                from: data)
            attachmentsVc.attachments = attachments!
        }
        
        
        attachmentsVc.idBorTorC = base?.id as! String
        attachmentsVc.typeBorTorC = "b"
        
        //self.present(attachmentsVc, animated: true) {}
        self.navigationController?.pushViewController(attachmentsVc, animated: true)
        
        print(attachmentsVc.attachments)
        
        
    }
    
}

@available(iOS 13.0, *)
extension NestedViewController2: DelegateGroupTaskCell{
    
    func onTaskNameClickedForMoreInfo(task: TaskH?) {
        
        UtilsAlert.showInfo(message: task!.name)
        
    }
    
    
    func showMeetingTime(task: TaskH?) {
        
    }
    
    func showShowMeetingUrl(task: TaskH?) {
        if let link = task?.meetingUrl {
            self.openLinkAlertAction(link: link)
        }
        
    }
    
    func showStartDate(task: TaskH?) {
        //self.view.makeToast("start date")
        //UtilsAlert.showInfo(message: Utils.pureDate(dateBefore: task!.startDate))
        
    }
    
    func showAddDate(task: TaskH?) {
        //self.view.makeToast("end date")
        //UtilsAlert.showInfo(message: Utils.pureDate(dateBefore: task!.addDate))
        
    }
    
    func showDueDate(task: TaskH?) {
        //self.view.makeToast("due date")
        //UtilsAlert.showInfo(message: Utils.pureDate(dateBefore: task!.dueDate))
    }
    
    func showUsers(task: TaskH?) {
        //self.view.makeToast("users")
        self.users = task?.assignee as! [UserHere]
        showPopUpAllUsersViewController()
    }
    
    func showComments(task: TaskH?) {
        
        UserDefaults.standard.setValue(true, forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI)
        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        let tabBarController = self.tabBarController!
        tabBar.tag = 0
        
        
        
        //self.view.makeToast("comments")
        let name = "Board"
        // let name = "Comments"
        let commentsVc = UIStoryboard(name: name, bundle: .main)
            .instantiateViewController(withIdentifier:
                "CommentsViewController") as! CommentsViewController
        commentsVc.modalPresentationStyle = .formSheet
        commentsVc.modalTransitionStyle = .coverVertical
        
        
        commentsVc.comments = task?.comments as! [Comment]
        commentsVc.task = task
        
        
        
        //self.present(commentsVc, animated: true) {}
        self.navigationController?.pushViewController(commentsVc, animated: true)
        
    }
    
    func showAttachments(task: TaskH?) {
        
        UserDefaults.standard.setValue(true, forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI)
        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        let tabBarController = self.tabBarController!
        tabBar.tag = 0
        
        
        //self.view.makeToast("attachments")
        let name = "Board"
        // let name = "Comments"
        let attachmentsVc = UIStoryboard(name: name, bundle: .main).instantiateViewController(identifier: "AttachmentsVCId") as AttachmentsViewController
        
        
        attachmentsVc.attachments = task?.attachments as! [Attachment]
        attachmentsVc.idBorTorC = task?.id as! String
        attachmentsVc.typeBorTorC = "t"
        
        //self.view.makeToast("\(task?.attachments.count)")
        //self.present(attachmentsVc, animated: true) {}
        self.navigationController?.pushViewController(attachmentsVc, animated: true)
        
    }
    
    
    
}

@available(iOS 13.0, *)
extension NestedViewController2: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        //return 3
        
        if flag {
            print("yooooooo")
            return self.groups.count
        }else{
            //            return (self.base?.users!.count)!
            //return self.users.count
            return 1;
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        
        if flag {
            return self.tasksDic[section]!.count
            
        }else{
            return self.users.count
            //            return 1;
        }
    }
    
    
    func fillTaskCell(cell: GroupTaskCell2?,  indexPath: IndexPath){
        //        let text = "Cell at row \(indexPath.row) section \(indexPath.section)";
        let taskHere: [TaskH] = self.tasksDic[indexPath.section]!
        task = taskHere[indexPath.row]
        
        
        
        //        cell?.setTask(task: task)
        //        cell?.delegate = self
        //        cell?.lblTaskName.text = task?.name
        //        cell?.lblTaskDate.text = Utils.pureDate(dateBefore: task?.startDate)
        //        let progressVal: Float = Float(task!.progressValue) / Float(100)
        //        cell?.progress.setProgress(progressVal
        //            , animated: false)
        //        cell?.lblTaskStatus.text = task!.status.name
        //        //print("progress = \(task.progressValue)")
        //        //print("progress = \(progressVal)")
        //        //print("Gogo \(task.name)")
        //        let color = task?.status.color
        //        let uiColor = Utils.hexStringToUIColor(hex: color!)
        //        cell?.topViewStatusColor.progressTintColor = uiColor
        //print("ueueunxh = \(color)")
        
        
        cell?.setTask(task: task)
        cell?.delegate = self
        cell?.taskName.text = task?.name
        
        //cell?.taskDate.text = Utils.pureDate(dateBefore: task!.startDate)
        //        cell?.taskDate.text = Utils.pureDateTime(dateBefore: task!.startDate)
//        cell?.taskDate.text = Utils.pureDateTime(dateBefore: task!.dueDate)
        
         cell?.taskDate.text = task!.dueDate + " " + Utils.convert24To12(task!.dueDateTime)
        
        
        let progressVal: Float = Float(task!.progressValue) / Float(100)
        //cell?.taskProgress.value = CGFloat(progressVal)
        cell?.taskProgress.value = CGFloat(task!.progressValue)
        
        cell?.taskProgress.progressColor = Utils.hexStringToUIColor(hex: (task?.progressColor)!)
        
        let color = task?.status.color
        let uiColor = Utils.hexStringToUIColor(hex: color!)
        cell?.taskStatus.backgroundColor = uiColor
        cell?.taskStatus.text = " " + task!.status.name!
        cell?.taskStatus.layer.cornerRadius = 5
        cell?.taskStatus.layer.masksToBounds = true
        cell?.taskStatus.textAlignment = .center
        
        cell?.lblTaskInfoMainTitle.text = "Start Date:"
        //cell?.taskInfo.text = Utils.pureDate(dateBefore: task!.startDate)
//        cell?.taskInfo.text = Utils.pureDateTime(dateBefore: task!.startDate)
        cell?.taskInfo.text = task!.startDate + " " + Utils.convert24To12(task!.startDateTime)
        
        print("eroere = \(task?.startDate)  \(Utils.convert24To12(task!.startDateTime))")
        
        
        
    }
    
    //    func accessOverlappingImagesView(overlappedImagesView: WJXOverlappedImagesView?, images: [String]?){
    //        //let overlappedImagesView: WJXOverlappedImagesView?
    //        //= cell?.overlappedImagesView
    //        overlappedImagesView?.imageFetcher = { imagesView, imageView, url, index in
    //            // fetch image via YYWebImage
    //            //            imageView.yy_setImage(with: URL(string: url)!, placeholder: UIImage(named: "demo-avatar"))
    //
    //            // fetch image via Kingfisher
    //            //            imageView.kf.setImage(with: URL(string: url), placeholder: UIImage(named: "demo-avatar"))
    //
    //            // fetch image via SDWebImage
    //            imageView.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "demo-avatar"))
    //        }
    //        overlappedImagesView?.imageFetchCanceler = { imagesView, imageView, index in
    //            //            imageView.yy_cancelCurrentImageRequest()
    //            //            imageView.kf.cancelDownloadTask()
    //            imageView.sd_cancelCurrentImageLoad()
    //        }
    //        overlappedImagesView?.updateInTransaction { imagesView in
    //            imagesView.imageBorderWidth = 4
    //            imagesView.imageBorderColor = UIColor.white
    //            imagesView.imageHeight = 60
    //            imagesView.overlapDistance = 16
    //            imagesView.shouldShowMoreIndicatorImageViewWhenImageCountExceedsMaxLimit = true
    //            imagesView.maxLimit = 4
    //            //imagesView.imageUrls = self.imageUrls
    //            imagesView.imageUrls = images
    //
    //        }
    //
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? GroupTaskCell
        
        var cell: UITableViewCell?
        
        if flag {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath) as? GroupTaskCell2
            fillTaskCell( cell: cell as! GroupTaskCell2, indexPath: indexPath)
            
            return cell!
        }else{
            
            let cell = self.tableViewAllUsers!.dequeueReusableCell(withIdentifier: "CellUser", for: indexPath) as? CellUser
            let user = self.users[indexPath.row]
            print("Rorororo \(user.fullName)")
            print("Rorororo \(user.name)")
            print("Rorororo \(user.userName)")
            print("Rorororo \(user.shortName)")
            cell?.lblUserName.text = user.fullName
            
            if let image = user.userImage {
                if (!image.isEmpty && (image.starts(with: "http") || image.starts(with: "https"))) {
                    let url = URL(string: image)
                    cell?.ivUserPhoto.kf.setImage(with: url)
                }else{
                    cell?.ivUserPhoto.image = Utils.letterAvatarImage(chars: user.shortName!)
                }
            }else{
                cell?.ivUserPhoto.image = Utils.letterAvatarImage(chars: user.shortName!)
            }
            
            
            return cell!
        }
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        var sectionHeader: UITableViewHeaderFooterView?
        
        if flag {
            //        let sectionHeader = tableView.dequeueReusableCell(withIdentifier: sectionHeaderReuseIdentifier) as? GroupSectionHeader
            let header = tableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as! GroupSectionHeader2
            
            
            //        let group = self.groups[section]
            //        sectionHeader.labelTaskGroupName.text = group.name
            //        sectionHeader.seTask(task: group)
            //        let teamName = self.team?.teamName
            //        sectionHeader.labelTeamName.text = teamName
            //        print("teamName = \(teamName)")
            //        sectionHeader.delegateAttach = self
            
            
            
            let group = self.groups[section]
            header.seTask(task: group)
            if let teamName = self.team?.teamName, !teamName.isEmpty{
                header.teamName.text = teamName
            }else{
                header.teamName.text = "    "
            }
            header.delegateAttach = self
            
            return header
        }else{
            
            
            
        }
        
        return sectionHeader
    }
    
}

@available(iOS 13.0, *)
extension NestedViewController2: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1;
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width/5, height: collectionView.frame.width/2)
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.shortNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.cellIdLetterAvatar, for: indexPath) as! CellLetterAvatar
        
        let shortName =  self.shortNames[indexPath.row]
        print("soso = \(shortName)")
        
        // Circle avatar image with white border
        //        let circleAvatarImage = LetterAvatarMaker()
        //            .setCircle(true)
        //            .setUsername(shortName)
        //            .setBorderWidth(1.0)
        //            .setBackgroundColors([ .red ])
        //            .build()
        
        cell.imageView.image = Utils.letterAvatarImage(chars: shortName)
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}


// MARK: - LUExpandableTableViewDelegate

@available(iOS 13.0, *)
extension NestedViewController2: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        
        if flag {
            return 300
        }else{
            
            return 100
        }
        
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        
        
        if flag {
            return 60
        }else{
            
            return 0
        }
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //        //print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
        //        //        let boardData = self.nestedBoard[indexPath.section]
        //        //        let id  = boardData![indexPath.row].id
        //        //        print(id)
        //
        //
        //
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectSectionHeader sectionHeader: LUExpandableTableViewSectionHeader, atSection section: Int) {
        print("Did select section header at section \(section)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        print("Will display cell at section \(indexPath.section) row \(indexPath.row)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, willDisplaySectionHeader sectionHeader: LUExpandableTableViewSectionHeader, forSection section: Int) {
        print("Will display section header for section \(section)")
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, viewForFooterInSection section: Int) -> UIView? {
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
        
    }
    
    
}
