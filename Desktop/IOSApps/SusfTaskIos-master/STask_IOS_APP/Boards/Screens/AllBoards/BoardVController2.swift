//
//  BoradVController.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import MaterialActivityIndicator
import YNExpandableCell
import LUExpandableTableView
import RestEssentials
import SSCustomTabbar
import Foundation
import FileBrowser




@available(iOS 13.0, *)
class BoardVController2: UIViewController{
    
    var boardId: String = ""
    private var indicator = MaterialActivityIndicatorView()
    private let expandableTableView = LUExpandableTableView()
    private let cellReuseIdentifier = "BoardCell"
    private let sectionHeaderReuseIdentifier = "BoardSectionHeader"
    fileprivate var boardDataLst: [BoardDataListModel] = []
    fileprivate var nestedBoard: [Int: [NestedBoard]] = [:]
    //fileprivate nested: NestedBoard?
    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleOnRefresh), for: .valueChanged)
        
        return refresher
    }()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let lang = UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String
        print("kdsds = \(lang)")
        
        initViews()
        getAllBoards()
        //useingSwiftyRequest()
        setupExpandableTableView()
        
        
        
        //        let addImage = UIImage(systemName: "plus")
        let addImage = UIImage(named: "browse")
        let addBarButtonItem = UIBarButtonItem(image: addImage, style: .done, target: self, action: #selector(openFileBrowser))
        self.navigationItem.rightBarButtonItems  = [addBarButtonItem]
        
        
        
    }
    
    
    @objc func openFileBrowser(){
        
        //open the general folder
        let fileBrowser = FileBrowser()
        //fileBrowser.modalPresentationStyle = .overFullScreen
        self.present(fileBrowser, animated: true, completion: nil)
        //self.navigationController?.pushViewController(fileBrowser, animated: true)
        
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        print("JoJo view did appear")
        checkIfPushedFromNotificationVc()
        
        
        //        if let boardIdFromDidReceive = UserDefaults.standard.value(forKey: Constants.DATA_BOARD_ID){
        //            print("boardIdFromDidReceive =  \(boardIdFromDidReceive)")
        //            self.view.makeToast("boardIdFromDidReceive = \(boardIdFromDidReceive)")
        //        }
        
        
        //        self.view.makeToast("viewDidAppear")
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        //        self.view.makeToast("viewWillAppear")
        
        
    }
    
    @objc func handleOnRefresh(){
        print("refreshing....")
        
        
        getAllBoards()
        
    }
    
    
    
    
    func checkIfPushedFromNotificationVc(){
        if let tabBar = self.tabBarController!.tabBar as? SSCustomTabBar{
            if tabBar.tag == 2{
                print("tabbar tag = \(tabBar.tag)")
                if let SAVED_USER_NOTIFI = UserDefaults.standard.object(forKey: Constants.SAVED_USER_NOTIFI) as? Data {
                    let decoder = JSONDecoder()
                    if let loadedNoti = try? decoder.decode(Notification.self, from: SAVED_USER_NOTIFI) {
                        let id = loadedNoti.paramStr![0]
                        //                    let id = loadedNoti.id
                        print(loadedNoti.paramStr![0])
                        tabBar.tag == 0//set to default
                        let vc = self.storyboard?.instantiateViewController(identifier: "NestedViewController") as! NestedViewController2
                        vc.boardId = id;
                        self.navigationController?.pushViewController(vc, animated: true)
                        
                    }
                }else{
                    if let SAVED_USER_TASK = UserDefaults.standard.object(forKey: Constants.SAVED_USER_TASK) as? Data {
                        let decoder = JSONDecoder()
                        if let loadedTask = try? decoder.decode(Task.self, from: SAVED_USER_TASK) {
                            //                    let id = loadedTask.id
                            //                    let id = loadedTask.taskID
                            let id = loadedTask.boardId
                            print("id_ooo = \(id)")
                            //                    print(loadedTask.paramStr![0])
                            tabBar.tag == 0//set to default
                            let vc = self.storyboard?.instantiateViewController(identifier: "NestedViewController") as! NestedViewController2
                            vc.boardId = id!;
                            self.navigationController?.pushViewController(vc, animated: true)
                            
                        }
                    }
                }
                
                
                
                
            }else{
                print("tabbar tag = \(tabBar.tag)")
                
                
                
            }
            
        }
        
        if let boardId = UserDefaults.standard.string(forKey: Constants.DATA_BOARD_ID) {
            UserDefaults.standard.removeObject(forKey: Constants.DATA_BOARD_ID)
            
            let vc = self.storyboard?.instantiateViewController(identifier: "NestedViewController") as! NestedViewController2
            vc.boardId = boardId as! String;
            self.navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    
    
    func initViews(){
        indicator = UtilsProgress.createProgress(view: self.view, indicator: indicator)!
    }
    
    func setupExpandableTableView(){
        view.addSubview(expandableTableView)
        
        //        expandableTableView.register(BoardCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        expandableTableView.register(UINib(nibName: cellReuseIdentifier, bundle: .main), forCellReuseIdentifier: cellReuseIdentifier)
        expandableTableView.register(UINib(nibName: sectionHeaderReuseIdentifier, bundle: Bundle.main), forHeaderFooterViewReuseIdentifier: sectionHeaderReuseIdentifier)
        
        expandableTableView.expandableTableViewDataSource = self
        expandableTableView.expandableTableViewDelegate = self
        
        expandableTableView.separatorStyle = .none
        
        expandableTableView.refreshControl = self.refresher
        
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        
        expandableTableView.frame = view.bounds
        expandableTableView.frame.origin.y += 20
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        indicator.stopAnimating()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        
    }
    
    func useingSwiftyRequest(){
        let url1 = Constants.BASE_URL + Constants.Ends.END_POINT_ALL_BOARDS
        // Create URL
        let url = URL(string: url1)
        guard let requestUrl = url else { fatalError() }
        // Create URL Request
        var request = URLRequest(url: requestUrl)
        
        request.setValue("application/json", forHTTPHeaderField: "Accept")
        request.setValue("Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IlU4NDE5NDQ5ODg1NzIiLCJlbWFpbCI6ImFkbWluQGFkbWluLmNvbSIsImlhdCI6MTU4NTg0NTQ4NCwiZXhwIjoxNTg4NDM3NDg0fQ.41tpbokPOqACPVamG1zgIVBoKlCbgmyzGL7aoqkVZFY", forHTTPHeaderField: "Authorization")
        request.setValue("ar", forHTTPHeaderField: "lang")
        
        // Specify HTTP Method to use
        request.httpMethod = "GET"
        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            //            if let response = response as? HTTPURLResponse {
            //                print("Response HTTP Status code: \(response.statusCode)")
            //            }
            
            // Convert HTTP Response Data to a simple String
            if let data = data, let dataString = String(data: data, encoding: .utf8) {
                //print("Response data string:\n \(dataString)")
                
                let todoItem = self.parseJSON(data: data)
                print(todoItem)
                
                
            }
            
        }
        
        task.resume()
        
    }
    
    
    func parseJSON(data: Data) -> AllBoardsData? {
        
        var returnValue: AllBoardsData?
        do {
            returnValue = try JSONDecoder().decode(AllBoardsData.self, from: data)
        } catch {
            print("Error took place\(error.localizedDescription).")
        }
        
        return returnValue
    }
    
    func getAllBoards(){
        self.startLoading()
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .contentType("Content-Type"),
            .acceptCharset("utf-8"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token)),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
            .init(name: "tz", value: TimeZone.current.identifier)
            
            
        ]
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_ALL_BOARDS
        debugPrint(url)
        
        AF.request(url,method: .get,
                   //encoding: JSONEncoding.default,
            headers: headers)
            .response { response in
                
                //debugPrint("resp \(response)")
                switch response.result {
                case .success(let data):
                    //debugPrint( "Success: \(response.value)")
                    self.stopLoading()
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    //debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        //                        let dataJson = swiftyData["data"]["BoardDataList"]
                        //                        let name = dataJson[0]["name"].stringValue
                        //                        self.view.makeToast(name)
                        debugPrint(message)
                        //print(dataJson)
                        
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let boardData = try decoder.decode(AllBoardsData.self, from: data)
                            
                            self.boardDataLst = boardData.data?.BoardDataList as! [BoardDataListModel]
                            
                            for n in 0...self.boardDataLst.count-1 {
                                self.nestedBoard[n] = self.boardDataLst[n].nestedBoard
                            }
                            
                            
                            
                            self.expandableTableView.reloadData()
                            self.refresher.endRefreshing()
                            
                            
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
    
    func stopLoading(){
        // self.indicator.stopAnimating()
        //        self.view.hideAllToasts()
        //        self.view.hideToast()
        self.view.hideToastActivity()
    }
    
    func startLoading(){
        // self.indicator.stopAnimating()
        //        self.view.hideAllToasts()
        //        self.view.hideToast()
        self.view.makeToastActivity(.center)
    }
    
    
}


@available(iOS 13.0, *)
extension BoardVController2: LUExpandableTableViewDataSource {
    func numberOfSections(in expandableTableView: LUExpandableTableView) -> Int {
        //return 3
        return self.boardDataLst.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, numberOfRowsInSection section: Int) -> Int {
        //return 3
        //return self.boardDataLst.count
        return self.nestedBoard[section]!.count
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = expandableTableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier) as? BoardCell else {
            assertionFailure("Cell shouldn't be nil")
            return UITableViewCell()
        }
        
        //        let text = "Cell at row \(indexPath.row) section \(indexPath.section)";
        let array: [NestedBoard] = self.nestedBoard[indexPath.section]!
        let text = array[indexPath.row].name
        debugPrint(text)
        //cell.label.text = text
        cell.lblTitle.text = text
        
        return cell
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, sectionHeaderOfSection section: Int) -> LUExpandableTableViewSectionHeader {
        guard let sectionHeader = expandableTableView.dequeueReusableHeaderFooterView(withIdentifier: sectionHeaderReuseIdentifier) as? BoardSectionHeader else {
            assertionFailure("Section header shouldn't be nil")
            return LUExpandableTableViewSectionHeader()
        }
        
        
        let boardData = boardDataLst[section]
        //sectionHeader.label.text = "Section \(section)"
        sectionHeader.label.text = boardData.name
        sectionHeader.labelColor.backgroundColor = Utils.hexStringToUIColor(hex: boardData.color!)
        sectionHeader.iconLocker.isHidden = !boardData.isPrivate!
        
        return sectionHeader
    }
}

// MARK: - LUExpandableTableViewDelegate

@available(iOS 13.0, *)
extension BoardVController2: LUExpandableTableViewDelegate {
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 50
    }
    
    func expandableTableView(_ expandableTableView: LUExpandableTableView, heightForHeaderInSection section: Int) -> CGFloat {
        /// Returning `UITableViewAutomaticDimension` value on iOS 9 will cause reloading all cells due to an iOS 9 bug with automatic dimensions
        return 70
    }
    
    // MARK: - Optional
    func expandableTableView(_ expandableTableView: LUExpandableTableView, didSelectRowAt indexPath: IndexPath) {
        //print("Did select cell at section \(indexPath.section) row \(indexPath.row)")
        let boardData = self.nestedBoard[indexPath.section]
        let board = boardData![indexPath.row]
        let id  = board.id
        print(id)
        
        //        let nestedViewController = NestedViewController()
        let nestedViewController = UIStoryboard(name: "Board", bundle: .main).instantiateViewController(identifier: "NestedViewController") as NestedViewController2
        
        nestedViewController.boardId = id!;
        
        
        
        self.navigationController!.pushViewController(nestedViewController, animated: true)
        
        
        UserDefaults.standard.setValue(true, forKey: Constants.FROM_ALL_BOARDS_OR_NOTIFI)
        
        
        
        
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
    
    func expandableTableView(_ expandableTableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0
    }
}

