//
//  LoginViewController.swift
//  ImageSlider
//
//  Created by A on 4/1/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import UIKit
import Toast_Swift
import Alamofire
import SwiftyJSON
import MaterialActivityIndicator
//import NVActivityIndicatorView
import SSCustomTabbar
import CDAlertView
import Firebase
import FirebaseDatabase
import Messages



@available(iOS 13.0, *)
class LoginViewController: UIViewController {
    
    
    var fcmToken: String = ""
    @IBOutlet weak var privacyLabel: UILabel!
    @IBOutlet weak var viewPassword: CardView2!
    @IBOutlet weak var lblForgotPassword: UILabel!
    @IBOutlet weak var btnLogin: UIButton!
    let userDefaults: UserDefaults = UserDefaults.standard
    @IBOutlet weak var etEnterEmail: UITextField!
    @IBOutlet weak var etEnterPassword: UITextField!
    //    let activityIndicatorView:NVActivityIndicatorView?
    private var indicator = MaterialActivityIndicatorView()
    var flagRegister = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.privacyLabel.attributedText = NSAttributedString(string: NSLocalizedString("privacy", comment: ""), attributes:
            [.underlineStyle: NSUnderlineStyle.single.rawValue])
        self.privacyLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleOnPrivacyClicked)))
        privacyLabel.isUserInteractionEnabled = true
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)) , name:UIResponder.keyboardWillHideNotification, object: nil);
        
        
        btnLogin.isEnabled = false
        
        lblForgotPassword.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleForgotPassword)))
        lblForgotPassword.isUserInteractionEnabled = true
        
        
        etEnterEmail.addTarget(self, action: #selector(textFieldDidChange(_:)),
                               for: .editingChanged)
        
        etEnterPassword.addTarget(self, action: #selector(textFieldDidChange(_:)),
                                  for: .editingChanged)
        etEnterEmail.borderStyle = .none
        etEnterPassword.borderStyle = .none
//        etEnterEmail.attributedPlaceholder = NSAttributedString(string: "Email",attributes: [NSAttributedString.Key.foregroundColor: Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)])
//        etEnterPassword.attributedPlaceholder = NSAttributedString(string: "Password",attributes: [NSAttributedString.Key.foregroundColor: Utils.hexStringToUIColor(hex: Constants.Colors.GREEN)])
//
        
        
        //        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: type, color: color, padding: padding)
        
        
        //setupActivityIndicatorView()
        indicator = UtilsProgress.createProgress(view: self.view, indicator: indicator)!
        
        
        
        etEnterEmail.delegate = self
        etEnterPassword.delegate = self;
        
        
        
        self.view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(MainViewClicked)))
        
        
        //        if self.flagRegister {
        //            self.privacyLabel.isHidden = true
        //            self.lblForgotPassword.isHidden = true;
        //            self.btnLogin.setTitle("Create new Account", for: .normal)
        //            self.btnLogin.isUserInteractionEnabled = true
        //            self.btnLogin.isEnabled = true
        //            self.btnLogin.backgroundColor = Utils.hexStringToUIColor(hex: "#19AC89")
        //
        //
        //        }
        
        
//        FirebaseApp.configure()
//        Messaging.messaging().delegate = self
        let appDelegate = UIApplication.shared.delegate as! AppDelegate2
        self.fcmToken = appDelegate.fcmToken!
        
    
    }
    
    
    @objc func handleOnPrivacyClicked() {
        
        guard let url = URL(string: Constants.PRIVACY) else { return }
        UIApplication.shared.open(url)
        
    }
    
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -160 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    
    
    @objc func MainViewClicked(){
        self.view.endEditing(true)
    }
    
    @objc func handleForgotPassword(){
        //self.view.makeToast("forgot")
        self.userForgotPassword()
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        
        if textField == etEnterEmail {
            //            if Utils.isValidEmail(email: textField.text){
            //                viewPassword.isHidden = false
            //                viewPassword.fadeIn(duration: 0.7)
            //            }
            //            else{
            //                viewPassword.isHidden = true;
            //                viewPassword.fadeOut(duration: 0.7)
            //
            //            }
        }
        
        if textField == etEnterPassword {
            if etEnterPassword.text!.count >= 5 {
                //self.btnLogin.backgroundColor = UIColor.blue
                self.btnLogin.backgroundColor = Utils.hexStringToUIColor(hex: "#19AC89")
                self.btnLogin.isUserInteractionEnabled = true;
                self.btnLogin.isEnabled = true
            }else{
                self.btnLogin.backgroundColor = UIColor.lightGray
                self.btnLogin.isUserInteractionEnabled = false
                
            }
        }
        
        
        
    }
    
    
    @IBAction func btnBack(_ sender: Any) {
        
        self.dismiss(animated: true) {
            
        }
        
    }
    
    
    
    @IBAction func btnLogin(_ sender: Any) {
        debugPrint("login")
        //        self.view.makeToast("This is a piece of toast")
        // display toast with an activity spinner
        
        
        checkData()
        
    }
    
    
    func checkData(){
        if etEnterEmail.text!.isEmpty{
            self.view.makeToast("Enter email address", duration: 3.0, position: .center)
            
        }else{
            if !Utils.isValidEmail(email: etEnterEmail.text!){
                self.view.makeToast("Enter valid email", duration: 3.0, position: .center)
                
            }else{
                
                if etEnterPassword.text!.isEmpty{
                    self.view.makeToast("Enter your password", duration: 3.0, position: .center)
                    
                }
                else{
                    
//                    InstanceID.instanceID().getID( handler: {instanceId, error in
//                        print("instance id = \(instanceId)")
//                        self.loginNow(firebaseInstanceId: instanceId!)
//                    })
//                    let defaults = UserDefaults.standard
//                    let fcmToken: String = defaults.value(forKey: Constants.FCM_TOKEN) as! String
                    print("fcm token = \(fcmToken)")
                    self.loginNow(firebaseInstanceId: fcmToken)
                    
                    guard let token = Messaging.messaging().fcmToken else {
                        print("Cannot find fcm token.")
                        return
                    }
                    self.loginNow(firebaseInstanceId: token)
                }
            }
        }
        //self.loginNow()
    }
    
    
    
    
    func loginNow(firebaseInstanceId: String){
        
        showLoading()
        
        //                headers.put("lang", PreferenceProcessor.getInstance(mContext).getStr(MyConfig.MyPrefs.LANG, "en"));
        let headers: HTTPHeaders = [
            //.acceptLanguage("ar"),
            .accept("application/json")
            ,.acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
             .init(name: "tz", value: TimeZone.current.identifier)
        ]
        let parameters: [String: Any] = [
            //            "email": "admin@admin.com",
            //            "password" : "admin123",
            
            "email": "\(self.etEnterEmail.text!)",
            "password" : "\(self.etEnterPassword.text!)",
            
            "deviceId" : firebaseInstanceId,
        ]
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_LOGIN
        debugPrint(url)
        
        //        let manager = AF.Ses.default
        //        manager.session.configuration.timeoutIntervalForRequest = 120
        AF.request(url,method: .post, parameters: parameters, headers: headers)
            //.response { response in
            .responseJSON { response in
                //debugPrint("resp \(response)")
                
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: \(response.value)")
                    //self.view.hideAllToasts()
                    //self.indicator.stopAnimating()
                    self.stopLoading()
                    
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            let decoder = JSONDecoder()
                            let userData = try decoder.decode(UserData.self, from: data)
                            debugPrint(userData.data.user.email)
                            debugPrint(userData.data.user.firstName)
                            debugPrint(userData.data.user.id)
                            debugPrint(userData.data.user.mobile)
                            debugPrint(userData.data.user.lastName)
                            debugPrint("tokenHoho \(userData.data.token)")
                            
                            
                            let encoder = JSONEncoder()
                            if let encoded = try? encoder.encode(userData) {
                                let defaults = UserDefaults.standard
                                defaults.set(encoded, forKey: Constants.SAVED_USER)
                            }
                            
                            //retreiveUserData
                            let savedPerson =  Utils.fetchSavedUser()
                            if savedPerson != nil{
                                //savedPerson?.message
                                
                            }
                            
                            
                        } catch let error {
                            print(error)
                        }
                        
                        //self.dismiss(animated: true) {}
                        let homeVc = UIStoryboard(name: "Board", bundle: .main)
                            .instantiateViewController(withIdentifier: "HomePage") as! SSCustomTabBarViewController
                        self.present(homeVc, animated: true) {}
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
    
    
    func userForgotPassword(){
        
        if etEnterEmail.text!.isEmpty {
            self.view.makeToast("Enter your email address")
            etEnterEmail.isError(baseColor:
                //UIColor.gray.cgColor,
                UIColor.red.cgColor,
                                 numberOfShakes: 3,
                                 revert: true)
            
            return
        }
        
        if !Utils.isValidEmail(email: etEnterEmail.text) {
            self.view.makeToast("Enter valid email")
            etEnterEmail.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            return
        }
        
        
        showLoading()
        let headers: HTTPHeaders = [
            .accept("application/json"),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
            .init(name: "tz", value: TimeZone.current.identifier)

        ]
        let parameters: [String: Any] = [
            "email": "\(self.etEnterEmail.text!)",
        ]
        //let url = Constants.BASE_URL + Constants.Ends.END_POINT_USER_FORGOT_PASS
        let url = Constants.BASE_URL + "user/forgot-password"
        debugPrint(url)
        
        AF.request(url,
                   method: .post,
                   parameters: parameters
            //,headers: headers
        )
            //.response { response in
            .responseJSON { response in
                debugPrint("resp \(response)")
                switch response.result {
                case .success(let data):
                    debugPrint( "Success: \(response.value)")
                    self.stopLoading()
                    let swiftyData = JSON(response.value)
                    let successful = swiftyData["successful"].intValue
                    debugPrint("state \(successful)")
                    if successful == 1{
                        let message = swiftyData["message"].stringValue
                        debugPrint(message)
                        guard let data = response.data else { return }
                        do {
                            
                            
                            
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
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        indicator.stopAnimating()
    }
    
    
}

//@available(iOS 13.0, *)
//extension LoginViewController {
//    private func setupActivityIndicatorView() {
//        view.addSubview(indicator)
//        setupActivityIndicatorViewConstraints()
//    }
//
//    private func setupActivityIndicatorViewConstraints() {
//        indicator.translatesAutoresizingMaskIntoConstraints = false
//        indicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
//        indicator.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
//
//    }
//}


@available(iOS 13.0, *)
extension LoginViewController: UITextFieldDelegate{
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {   //delegate method
        if textField.isEqual(etEnterEmail) {
            etEnterEmail.resignFirstResponder()
            etEnterPassword.becomeFirstResponder()
        }
        if textField.isEqual(etEnterPassword) {
            textField.resignFirstResponder()
        }
        return true
    }
    
}


//extension LoginViewController: MessagingDelegate{
//
//    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
//        print("Firebase registration token2 : \(fcmToken)")
//        self.fcmToken = fcmToken
//
//        //saving for passing it to login api
////        let userDefaults = UserDefaults.standard
////        userDefaults.setValue(Constants.FCM_TOKEN, forKey: fcmToken)
//
//
//    }
//
//    func messaging(_ messaging: Messaging, didReceive remoteMessage: MessagingRemoteMessage) {
//        print("Message data = \(remoteMessage.appData)")
//
//    }
//
//}
