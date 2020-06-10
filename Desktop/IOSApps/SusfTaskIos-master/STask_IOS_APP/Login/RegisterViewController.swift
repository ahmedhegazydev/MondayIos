//
//  RegisterViewController.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 5/6/20.
//  Copyright © 2020 Ahmed Hegazy . All rights reserved.
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


class RegisterViewController: UIViewController {
    
    
    @IBOutlet weak var etPassword: UITextField!
    @IBOutlet weak var etEmail: UITextField!
    @IBOutlet weak var etPhone: UITextField!
    @IBOutlet weak var etLastName: UITextField!
    @IBOutlet weak var etFirstName: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name:UIResponder.keyboardWillShowNotification, object: nil);
               NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)) , name:UIResponder.keyboardWillHideNotification, object: nil);

        
        
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
            self.view.frame.origin.y = -140 // Move view 150 points upward
       }

       @objc func keyboardWillHide(sender: NSNotification) {
            self.view.frame.origin.y = 0 // Move view to original position
       }
       
    
    
    @IBAction func btnClose(_ sender: Any) {
        self.dismiss(animated: true) {}
        
        
    }
    
    
    @IBAction func btnRegister(_ sender: Any) {
        checkData()
    }
    
    func checkData(){
        if etFirstName.text!.isEmpty{
            self.view.makeToast("Enter firstname", duration: 3.0, position: .center)
            etFirstName.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
            
        }else{
            if etLastName.text!.isEmpty{
                self.view.makeToast("Enter lastname", duration: 3.0, position: .center)
                etLastName.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
                
            }else{
                if etPhone.text!.isEmpty{
                    self.view.makeToast("Enter phone", duration: 3.0, position: .center)
                    etPhone.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
                }else{
                    if !Utils.isValidEmail(email: etEmail.text!){
                        self.view.makeToast("Enter valid email", duration: 3.0, position: .center)
                        etEmail.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
                    }else{
                        
                        if etPassword.text!.isEmpty{
                            self.view.makeToast("Enter your password", duration: 3.0, position: .center)
                            etPassword.isError(baseColor: UIColor.gray.cgColor, numberOfShakes: 3, revert: true)
                        }else{
                            self.createNewAccount()
                        }
                        
                    }
                }
            }
        }
        
        
        
        
        
        
    }
    
    func createNewAccount(){
        
        showLoading()
        
        
        let headers: HTTPHeaders = [
            //.acceptLanguage("ar"),
            .accept("application/json"),
            .acceptLanguage(UserDefaults.standard.value(forKey: Constants.SELECTED_LANG) as! String),
            .init(name: "tz", value: TimeZone.current.identifier)

        ]
        let department: [String] = ["DEP5672864748"]
        
        let parameters: [String: Any] = [
            "firstName": "\(self.etFirstName.text!)",
            "lastName": "\(self.etLastName.text!)",
            "email" : "\(self.etEmail.text!)",
            "mobile" : "\(self.etPhone.text!)",
            "role" : "SR4384981365",
            "department" : "\(department)",
            "password" : "\(self.etPassword.text!)",
        ]
        let url = Constants.BASE_URL + Constants.Ends.END_POINT_REGISTER
        debugPrint(url)
        
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
                            
                            
                            //self.dismiss(animated: true) {}
                             UtilsAlert.showSuccess(message: "Account created successfully")
                            
                            
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
    
    
}
