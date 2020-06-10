//
//  MoreViewController.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit

@available(iOS 13.0, *)
class MoreViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
   
    var alertControllerLang: UIAlertController?

    lazy var refresher: UIRefreshControl = {
        let refresher = UIRefreshControl()
        refresher.tintColor = Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)
        refresher.addTarget(self, action: #selector(handleOnRefresh), for: .valueChanged)
        
        return refresher
    }()
    let userDefaults: UserDefaults = UserDefaults.standard
    @IBOutlet weak var tableView: UITableView!
    let array: [MoreItem] = [
//    MoreItem(title: "Langugage Settings", image: #imageLiteral(resourceName: "language")),
    MoreItem(title: "LogOut", image: #imageLiteral(resourceName: "exit_52")),
//    MoreItem(title: "Exit", image: #imageLiteral(resourceName: "exit_52")),
//    MoreItem(title: "Exit", image: #imageLiteral(resourceName: "exit_52")),
//    MoreItem(title: "Exit", image: #imageLiteral(resourceName: "exit_52")),
    
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        tableView.delegate = self
        tableView.dataSource = self;
        tableView.refreshControl = self.refresher
        
        
    }
    
    func showLanguagePicker() {
         
         alertControllerLang = UIAlertController(title: Constants.APP_NAME, message: "Select language", preferredStyle: .alert)
         
         //               let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: { (alert: UIAlertAction!) -> Void in
         //                   print("delete")
         //               })
         //
         //               let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert: UIAlertAction!) -> Void in
         //                   print("Cancel")
         //               })
         
         let arabic = UIAlertAction(title: "Arabic", style: .default, handler: { (alert: UIAlertAction!) -> Void in
             //self.changeLanguage()
         })
         
         let english = UIAlertAction(title: "English", style: .default, handler: { (alert: UIAlertAction!) -> Void in
             //self.changeLanguage()
         })
         
         //               alertController.addAction(deleteAction)
         alertControllerLang!.addAction(arabic)
         alertControllerLang!.addAction(english)
         //               alertController.addAction(maybeAction)
         
         self.present(alertControllerLang!, animated: true, completion: nil)
         
     }
    
    
    
    @objc func handleOnRefresh(){
            print("refreshing....")
       
        let deadline = DispatchTime.now() + .milliseconds(400)
        DispatchQueue.main.asyncAfter(deadline: deadline) {
            self.refresher.endRefreshing()
        }
        
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1;
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
       }
       
       func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
           
        let cell  = tableView.dequeueReusableCell(withIdentifier: "MoreCellId", for: indexPath) as! CellMore
        var moreItem = self.array[indexPath.row];
        cell.myImage?.image = moreItem.image
        cell.myText?.text = moreItem.title
        
        return cell;
        
       }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let pos = indexPath.row
             debugPrint("pos  = \(pos)")
             if pos == 0 {
                //showLanguagePicker()
                Utils.logout(viewController: self)
             }else{
                Utils.logout(viewController: self)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

}
