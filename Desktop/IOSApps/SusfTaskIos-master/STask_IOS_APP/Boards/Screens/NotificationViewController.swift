//
//  NotificationViewController.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
//import BetterSegmentedControl
import Alamofire
import SwiftyJSON
import MaterialActivityIndicator
import SSCustomTabbar

@available(iOS 13.0, *)
class NotificationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        return refresher
        
    }()
    let headers: HTTPHeaders = [
        .accept("application/json"),
        .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
        .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
        .init(name: "tz", value: TimeZone.current.identifier)

        
    ]
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var notifications: [Notification] = []
    //     var notifications: [Notification] = [
    //        Notification(isSeen: true, id: "212", msg: "MESSAGE", nType: "C", byName: ByName(rawValue: "")!, paramStr: [], time: "20-20-20"),
    //        Notification(isSeen: true, id: "212", msg: "MESSAGE", nType: "C", byName: ByName(rawValue: "")!, paramStr: [], time: "20-20-20"),
    //
    //    ]
    var tasks: [Task] = []
    @IBOutlet weak var tableView: UITableView!
    private var indicator = MaterialActivityIndicatorView()
    fileprivate var flag = true;
    //     fileprivate var flag = false;
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self;
        let nib = UINib(nibName: "NotificationTableViewCell", bundle: nil)
        self.tableView.register(nib, forCellReuseIdentifier: "CellNotification")
        self.tableView.refreshControl = self.refresher
        
        
        indicator = UtilsProgress.createProgress(view: self.view, indicator: indicator)!
        
        getAllNotifications()
        
        customizeTheSegemntControl()
        
        
        
    }
    
    
    @objc func handleRefresh(){
        
        getAllNotifications()
        
        
    }
    
    func setNotificationAsSeen(notification: Notification?, task: Task?){
        self.view.makeToastActivity(.center)
        //let url: String = Constants.BASE_URL + Constants.Ends.END_POINT_SET_NOTI_AS_SEEN + notification.id!
        var id: String = ""
        if flag {
            id = notification?.id as! String
        }else{
            id = task?.id as! String
        }
        let url  = Constants.BASE_URL + "task/notificationSeen/\(id)"
        
        debugPrint(url)
        AF.request(url,method: .put,
                   headers: headers)
            //.response { response in
            .responseJSON { response in
                self.view.hideToastActivity()
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: notifi set as seen \(response.value)")
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            let msg = "Notification set as seen"
                            //Loaf(msg, state: .success, sender: self).show()
                            print(msg)
                            //self.view.makeToast(msg)
                            
                            
                            
                            if notification?.nType == "meeting"{
                                
                            }else{
                                
                                self.gotoNestedBoard(self.tabBarController!)
                            }
                            
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
    
    func customizeTheSegemntControl(){
        //change-font-color-of-uisegmentedcontrol to white
        //       let font = UIFont.systemFont(ofSize: 30)
        //        self.segmentControl.setTitleTextAttributes([NSAttributedString.Key.font: font], for: .normal)
        
        //         let titleTextAttributesNormal = [NSAttributedString.Key.foregroundColor: UIColor.black]
        let fontBold = UIFont.boldSystemFont(ofSize: 12)
        // let font = UIFont(name: "DINCondensed-Bold", size: 20)
        self.segmentControl.setTitleTextAttributes([ NSAttributedString.Key.font : fontBold,NSAttributedString.Key.foregroundColor: UIColor.black ], for: .normal)
        self.segmentControl.setTitleTextAttributes([ NSAttributedString.Key.font : fontBold,NSAttributedString.Key.foregroundColor: Utils.hexStringToUIColor(hex: "#FFFFFF") ],  for: .selected)
        
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        indicator.stopAnimating()
    }
    
    @IBAction func onSementedCilcked(_ sender: UISegmentedControl) {
        //Notifications
        if sender.selectedSegmentIndex == 0{
            //debugPrint("end point")
            flag = true;
            
        }else{//Tasks
            //debugPrint("FCM")
            flag = false;
        }
        self.tableView.reloadData()
    }
    
    
    func getAllNotifications(){
        //self.view.makeToastActivity(.center)
        //indicator.startAnimating()
        self.showLoading()
        
        let headers: HTTPHeaders = [
            //.accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String)
            ,
            .init(name: "tz", value: TimeZone.current.identifier)

        ]
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_NOTIFICATIONS
        debugPrint(url)
        AF.request(url,method: .get,
                   //encoding: JSONEncoding.default,
            headers: headers)
            .response { response in
                //.responseJSON { response in
                //debugPrint("resp \(response)")
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: \(response.value)")
                    //self.view.hideAllToasts()
                    //self.indicator.stopAnimating()
                    self.stopLoading()
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    //let successful = swiftyData["successful"].boolValue
                    //debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        //debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let notificationData = try decoder.decode(NotificationData.self, from: data)
                            self.notifications = (notificationData.data?.notification)!
                            self.tasks = (notificationData.data?.tasks)!
                            //                            for n in 0...self.notifications.count - 1 {
                            //                                //print(self.notifications[n].msg)
                            //                                print(self.notifications[n].nType)
                            //                            }
                            self.tableView.reloadData()
                            
                            
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
    
    
    func stopLoading(){
        //self.indicator.stopAnimating()
        self.view.hideToastActivity()
    }
    
    func showLoading(){
        self.view.makeToastActivity(.center)
        //        indicator.startAnimating()
    }
    
    func addDashedBottomBorder(to cell: UITableViewCell) {
        //let color = UIColor.black.cgColor
        let color = Utils.hexStringToUIColor(hex: "#EDEAEA").cgColor
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let frameSize = cell.frame.size
        let shapeRect = CGRect(x: 0, y: 0, width: frameSize.width, height: 0)
        
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: frameSize.width/2, y: frameSize.height)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = color
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPhase = 3.0 // Add "lineDashPhase" property to CAShapeLayer
        shapeLayer.lineDashPattern = [9,6]
        shapeLayer.path = UIBezierPath(roundedRect: CGRect(x: 0, y: shapeRect.height, width: shapeRect.width, height: 0), cornerRadius: 0).cgPath
        
        cell.layer.addSublayer(shapeLayer)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if flag{
            return notifications.count
        }else{
            return tasks.count
        }
        return notifications.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CellNotification", for: indexPath) as! NotificationTableViewCell
        
        addDashedBottomBorder(to: cell)
        
        var task: Task? = nil;
        var notification: Notification? = nil;
        
        if flag{
            notification = self.notifications[indexPath.row]
            cell.lblNotifiData.text = notification?.msg
            cell.lblUserName.text = notification?.byName?.capitalized
            //            cell.lblDate.text = Utils.pureDate(dateBefore: (notification?.time)!)
            cell.lblDate.text = Utils.pureDateTime(dateBefore: (notification?.time)!)
            //            let url  = URL(string: notification.u)
            //            cell.ivUserImage.kf.setImage(with: url)
            
            if (notification?.isSeen)! {
                cell.viewColor.isHidden = true
            }else{
                cell.viewColor.isHidden = false;
            }
            
            //b m/c t meeting
            //default
            print(notification?.nType)
            let image: UIImage?
            switch notification?.nType {
            case "b":
                image = UIImage(named: "noti1")
                break
            case "m":
                image = UIImage(named: "noti2")
                break
            case "c":
                image = UIImage(named: "noti2")
                break
            case "t":
                image = UIImage(named: "noti3")
                break
            case "meeting":
                image = UIImage(named: "noti4")
                break
            default:
                image = UIImage(named: "noti5")
                break
            }
            cell.ivUserImage.image = image
            
            
            
        }else{
            task = self.tasks[indexPath.row]
            cell.lblNotifiData.text = task?.name
            cell.lblUserName.text = task?.name?.capitalized
            cell.lblDate.text = Utils.pureDateTime(dateBefore: (task?.dueDate)!)
            cell.viewColor.isHidden = true;
//            cell.ivUserImage.image = UIImage(named: "noti5")
            cell.ivUserImage.image =  UIImage(named: "noti3")
            
            
        }
        
        
        
        
        
        return cell;
        //return UITableViewCell()
    }
    
    
    fileprivate func gotoNestedBoard(_ tabBarController: UITabBarController) {
        let index = 0
        tabBarController.selectedIndex = index
        tabBarController.selectedViewController = tabBarController.viewControllers![index]
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let tabBar = self.tabBarController!.tabBar as! SSCustomTabBar
        let tabBarController = self.tabBarController!
        tabBar.tag = 2 //for receiving after viewdidload
        //        let boardId = notifi.paramStr![0]
        //print(boardId)
        
        
        UserDefaults.standard.setValue(false, forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI)
        
        let encoder = JSONEncoder()
        let defaults = UserDefaults.standard
        let pos = indexPath.row
        var task: Task? = nil;
        var notification: Notification? = nil;
        if flag{
            //notifi
            notification = self.notifications[pos]
            //saving it for the receiving of BoardVc -> NestedVc
            
            if let encoded = try? encoder.encode(notification) {
                defaults.set(encoded, forKey: Constants.SAVED_USER_NOTIFI)
            }
            defaults.removeObject(forKey: Constants.SAVED_USER_TASK)
            
            self.setNotificationAsSeen(notification: notification, task: nil)
            
        }else{
            //task
            task = self.tasks[pos]
            if let encoded = try? encoder.encode(task) {
                defaults.set(encoded, forKey: Constants.SAVED_USER_TASK)
            }
            defaults.removeObject(forKey: Constants.SAVED_USER_NOTIFI)
            //            self.setNotificationAsSeen(notification: nil, task: task)
            self.gotoNestedBoard(self.tabBarController!)
            
            
        }
        
        //        debugPrint("pos  = \(pos)")
        //        let notifi = self.notifications[indexPath.row]
        //        print(notifi.id)
        //
        //
        //
        
        
        //directing to
        //gotoNestedBoard(tabBarController)
        
        
        
        //        let boradVc = tabBarController.selectedViewController as! BoardVController2
        
        //        nestedBoardVc.boardId = boardId
        //        tabBarController.selectedViewController = nestedBoardVc
        
        //        let nested = (self.storyboard?.instantiateViewController(identifier: "NestedViewController"))! as NestedViewController2
        //        nested.modalPresentationStyle = fullscr
        //        self.present(nested, animated: true) {}
        
        
        
        
    }
    
}
