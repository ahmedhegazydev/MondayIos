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


@available(iOS 13.0, *)
class BoardVController: UIViewController
//    ,YNTableViewDelegate
{
    
    @IBOutlet var ynTableView: YNTableView!
    private var indicator = MaterialActivityIndicatorView()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        indicator = UtilsProgress.createProgress(view: self.view, indicator: indicator)!
        
        getAllBoards()
       // expandableSample1()
        expandableSample2()
        
    }
    
     func expandableSample2(){
        
    }
    
    func expandableSample1(){
        //        let cells = ["YNExpandableCellEx","YNSliderCell","YNSegmentCell"]
        //        self.ynTableView.registerCellsWith(nibNames: cells, and: cells)
        //        self.ynTableView.registerCellsWith(cells: [UITableViewCell.self as AnyClass], and: ["YNNonExpandableCell"])
        //
        //        self.ynTableView.ynDelegate = self
        //        self.ynTableView.ynTableViewRowAnimation = .top
                
                //               self.expandAllButton.action = #selector(self.expandAllButtonClicked)
                //               self.expandAllButton.target = self
                //               self.collapseAllButton.action = #selector(self.collapseAllButtonClicked)
                //               self.collapseAllButton.target = self
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        indicator.stopAnimating()
    }
    
    
    func getAllBoards(){
        self.view.makeToastActivity(.center)
        //        indicator.startAnimating()
        
        
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .authorization(bearerToken: (Utils.fetchSavedUser().data.token))
            
        ]
        //        let headers: HTTPHeaders = [
        //            "Authorization": "Bearer  \(Utils.fetchSavedUser()?.data.token)",
        //            "Accept": "application/json",
        //
        //        ]
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
                    //debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        //debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let boardData = try decoder.decode(AllBoardsData.self, from: data)
                            
                            
                            
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
        // self.indicator.stopAnimating()
        //        self.view.hideAllToasts()
        //        self.view.hideToast()
        self.view.hideToastActivity()
    }
    
    
    @objc func expandAllButtonClicked() {
        self.ynTableView.expandAll()
    }
    
    @objc func collapseAllButtonClicked() {
        self.ynTableView.collapseAll()
    }
    
    func tableView(_ tableView: YNTableView, expandCellWithHeightAt indexPath: IndexPath) -> YNTableViewCell? {
        let ynSliderCell = YNTableViewCell()
        ynSliderCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSliderCell.ID) as! YNSliderCell
        ynSliderCell.height = 142
        
        let ynSegmentCell = YNTableViewCell()
        ynSegmentCell.cell = tableView.dequeueReusableCell(withIdentifier: YNSegmentCell.ID) as! YNSegmentCell
        ynSegmentCell.height = 160
        
        if indexPath.section == 0 && indexPath.row == 1 {
            return ynSliderCell
        } else if indexPath.section == 0 && indexPath.row == 2 {
            return ynSegmentCell
        } else if indexPath.section == 0 && indexPath.row == 4 {
            return ynSegmentCell
        } else if indexPath.section == 1 && indexPath.row == 0 {
            return ynSegmentCell
        } else if indexPath.section == 1 && indexPath.row == 1 {
            return ynSliderCell
        } else if indexPath.section == 2 && indexPath.row == 2 {
            return ynSliderCell
        } else if indexPath.section == 2 && indexPath.row == 4 {
            return ynSliderCell
        }
        return nil
    }
    
    //    func tableView(_ tableView: YNTableView, expandCellAt indexPath: IndexPath) -> UITableViewCell? {
    //        let ynSliderCell = tableView.dequeueReusableCell(withIdentifier: YNSliderCell.ID) as! YNSliderCell
    //        let ynSegmentCell = tableView.dequeueReusableCell(withIdentifier: YNSegmentCell.ID) as! YNSegmentCell
    //
    //        if indexPath.section == 0 && indexPath.row == 1 {
    //            return ynSliderCell
    //        } else if indexPath.section == 0 && indexPath.row == 2 {
    //            return ynSegmentCell
    //        } else if indexPath.section == 0 && indexPath.row == 4 {
    //            return ynSegmentCell
    //        } else if indexPath.section == 1 && indexPath.row == 0 {
    //            return ynSegmentCell
    //        } else if indexPath.section == 1 && indexPath.row == 1 {
    //            return ynSliderCell
    //        } else if indexPath.section == 2 && indexPath.row == 2 {
    //            return ynSliderCell
    //        } else if indexPath.section == 2 && indexPath.row == 4 {
    //            return ynSliderCell
    //        }
    //        return nil
    //    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let expandableCell = tableView.dequeueReusableCell(withIdentifier: YNExpandableCellEx.ID) as! YNExpandableCellEx
        if indexPath.section == 0 && indexPath.row == 1 {
            expandableCell.titleLabel.text = "YNSlider Cell"
        } else if indexPath.section == 0 && indexPath.row == 2 {
            expandableCell.titleLabel.text = "YNSegment Cell"
        } else if indexPath.section == 0 && indexPath.row == 4 {
            expandableCell.titleLabel.text = "YNSegment Cell"
        } else if indexPath.section == 1 && indexPath.row == 0 {
            expandableCell.titleLabel.text = "YNSegment Cell"
        } else if indexPath.section == 1 && indexPath.row == 1 {
            expandableCell.titleLabel.text = "YNSlider Cell"
        } else if indexPath.section == 2 && indexPath.row == 2 {
            expandableCell.titleLabel.text = "YNSlider Cell"
        } else if indexPath.section == 2 && indexPath.row == 4 {
            expandableCell.titleLabel.text = "YNSlider Cell"
        } else {
            let nonExpandablecell = tableView.dequeueReusableCell(withIdentifier: "YNNonExpandableCell")
            nonExpandablecell?.textLabel?.text = "YNNonExpandable Cell"
            nonExpandablecell?.selectionStyle = .none
            return nonExpandablecell!
        }
        return expandableCell
        
    }
    
    func tableView(_ tableView: YNTableView, didSelectRowAt indexPath: IndexPath, isExpandableCell: Bool, isExpandedCell: Bool) {
        print("Selected Section: \(indexPath.section) Row: \(indexPath.row) isExpandableCell: \(isExpandableCell) isExpandedCell: \(isExpandedCell)")
    }
    
    func tableView(_ tableView: YNTableView, didDeselectRowAt indexPath: IndexPath, isExpandableCell: Bool, isExpandedCell: Bool) {
        print("Deselected Section: \(indexPath.section) Row: \(indexPath.row) isExpandableCell: \(isExpandableCell) isExpandedCell: \(isExpandedCell)")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 5
        }
//        else if section == 1 {
//            return 5
//        } else if section == 2 {
//            return 5
//        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        //return 30
        return 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        if section == 0 {
//            return "Section 0"
//        }
//        else if section == 1 {
//            return "Section 1"
//        } else if section == 2 {
//            return "Section 2"
//        }
        return ""
    }
}
