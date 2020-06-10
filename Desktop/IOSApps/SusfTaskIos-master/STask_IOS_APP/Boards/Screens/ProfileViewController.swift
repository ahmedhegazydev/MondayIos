//
//  ProfileViewController.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import SwiftyAvatar
import SDWebImage
import Toast_Swift
import Messages
import FirebaseMessaging


@available(iOS 13.0, *)
class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var lblNotificationDetails: UILabel!
    @IBOutlet weak var loader: UIActivityIndicatorView!
    
    let userDefaults: UserDefaults = UserDefaults.standard
    @IBOutlet weak var ivProfile: SwiftyAvatar!
    
    @IBOutlet weak var lblEmail: UILabel!
    
    @IBOutlet weak var lblPhone: UILabel!
    @IBOutlet weak var lblName: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        setUserData()
        
        
        let appDelegate = UIApplication.shared.delegate as? AppDelegate2
        let userInfo: [AnyHashable: Any]?
//        if let userInfo = appDelegate2!.userInfo{
//            if let data = userInfo["data"] as? NSDictionary {
//                //                if let byName = data["alert"] as? String {}
//                //                if let content = data["content"] as? String {}
//                //                if let boardId = data["boardId"] as? String {
//                //                    if !boardId.isEmpty{
//                //                        self.lblName.text = boardId
//                //                    }
//                //                }
//                if let theJSONData = try?  JSONSerialization.data(
//                    withJSONObject: data,
//                    options: .prettyPrinted
//                    ),
//                    let theJSONText = String(data: theJSONData,
//                                             encoding: String.Encoding.ascii) {
//                    print("JSON string = \n\(theJSONText)")
//                    self.lblNotificationDetails.text = theJSONText
//
//                }
//
//            }
//
//
//            //            let d : [String : Any] = remoteMessage.appData["notification"] as! [String : Any]
//            //            let body : String = d["body"] as! String
//            //            let title : String = d["title"] as! String
//            //            self.lblNotificationDetails.text = "body = \(body) title = \(title) appData = \(remoteMessage.appData)"
//            //
//
//
//        }
    }
    
    func setUserData(){
        let savedPerson = Utils.fetchSavedUser()
        let user = savedPerson.data.user
        
        debugPrint(user.firstName)
        debugPrint(user.lastName)
        debugPrint(user.userImage)
        debugPrint(user.mobile)
        debugPrint(user.mustChangePassword)
        debugPrint(user.id)
        
        self.lblName.text = user.firstName.capitalized + " " + user.lastName.capitalized
        self.lblName.text = self.lblName.text?.capitalized
        self.lblPhone.text = user.mobile
        self.lblEmail.text = user.email
        
        
        //loading image
        //user.userImage = ""
        
        //        ImageLoader.image(for: URL(string: user.userImage)!) { image in
        //                    self.ivProfile.image = image
        //                    self.loader.isHidden = true
        //            }
        //        if user.userImage.starts(with: "http") || user.userImage.starts(with: "https") {
        //              self.ivProfile.loadImageUsingCache(withUrl: user.userImage)
        //            print("existing http")
        //        }else{
        //            self.ivProfile.image = UIImage(named: "11")
        //            print("not exsisting http")
        //
        //        }
        
        
        
        if (!user.userImage.isEmpty && (user.userImage.starts(with: "http") || user.userImage.starts(with: "https"))) {
            let url = URL(string: user.userImage)
            self.ivProfile.sd_setImage(with: URL(string: user.userImage), placeholderImage: #imageLiteral(resourceName: "11"))
            
        }else{
            // Circle avatar image with white border
            self.ivProfile.image = Utils.letterAvatarImage(chars: user.shortName)
        }
        
    }
    
    @IBAction func btnEditProfile(_ sender: UIButton) {
        self.view.makeToast("Edit Profile", duration: 3.0, position: .center)
    }
    
    
    
}
