//
//  ViewController.swift
//  ImageSlider
//
//  Created by Eslam Shaker  on 12/6/18.
//  Copyright © 2018 Eslam Shaker . All rights reserved.
//

import UIKit
import SSCustomTabbar
import TextImageButton
import Firebase
import FirebaseDatabase
import MOLH


@available(iOS 13.0, *)
class MainViewController: UIViewController {
    
    
    @IBOutlet weak var btnRegister: UIButton!
    
    @IBOutlet weak var btnLogin: UIButton!
    let userDefaults: UserDefaults = UserDefaults.standard
    var alertControllerLang: UIAlertController?
    var ref: DatabaseReference?
    var refButtonFlag: DatabaseReference?
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    @IBOutlet weak var btnLang: TextImageButton!
    let images = [
        //        UIImage(named: "1"),
        //        UIImage(named: "2"),
        //        UIImage(named: "3"),
        //        UIImage(named: "4"),
        //        UIImage(named: "5")
        
        //        UIImage(named: "6"),
        //        UIImage(named: "7"),
        //        UIImage(named: "8"),
        //        UIImage(named: "9"),
        //        UIImage(named: "10"),
        //        UIImage(named: "11"),
        //        UIImage(named: "12"),
        
        UIImage(named: "pic1"),
        UIImage(named: "pic2"),
        
    ]
    
    var currentIndex = 0
    var timer : Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        //        let tap = UITapGestureRecognizer(target: self, action: #selector(onMainViewClick))
        //        self.alertControllerLang?.view.addGestureRecognizer(tap)
        
        
        btnLang.titleLabel?.text = LocalizationSystem.sharedInstance.localizedStringForKey(key: "btn_select_lang", comment: "")
        
        
        checkTheSwitchedFirebaseUrl()
        checkTheRegisterButtonFlag()
        
        
        let savedPerson =  Utils.fetchSavedUser()
        print("login token = \(savedPerson.data.token)")
        
    }
    
    func checkTheRegisterButtonFlag(){
        self.btnLogin.isUserInteractionEnabled = false
        self.btnLogin.isEnabled = false
        
        self.view.makeToastActivity(.center)
        self.refButtonFlag = Database.database().reference()
            .child("register_button").child("flag")
        refButtonFlag!.observe(.value) { (snapshot) in
            //            snapshot.ref.removeAllObservers()
            print(snapshot.value)
            
            self.view.hideToastActivity()
            self.btnLogin.isUserInteractionEnabled = true
            self.btnLogin.isEnabled = true
            
            let registerBtnFlag = snapshot.value as! Bool
            print("registerBtnFlag = \(registerBtnFlag)")
            self.btnRegister.isHidden = registerBtnFlag
            
            
            
        }
    }
    
    func checkTheSwitchedFirebaseUrl(){
        self.btnLogin.isUserInteractionEnabled = false
        self.btnLogin.isEnabled = false
        
        self.view.makeToastActivity(.center)
        self.ref = Database.database().reference()
        ref!.observe(DataEventType.value) { (snapshot) in
            //            snapshot.ref.removeAllObservers()
            
            let dic = snapshot.value as? [String : AnyObject] ?? [:]
            print(dic)
            let url: String = dic["url"] as! String
            let flag: Bool = (dic["flag"] != nil)
            //            print(url)
            //            print(flag)
            
            self.view.hideToastActivity()
            self.btnLogin.isUserInteractionEnabled = true
            self.btnLogin.isEnabled = true
            
            if flag {
                //saving
                self.userDefaults.setValue(url, forKey: Constants.SELECTED_BASE_URL)
                let savedUrl: String = self.userDefaults.value(forKey: Constants.SELECTED_BASE_URL) as! String
                print("osososo = \(savedUrl)")
                print(Constants.BASE_URL)
                
            }else{
                
            }
            
        }
    }
    
    
    
    
    func checkUserLogin(){
        //retreiveUserData
        let savedPerson =  Utils.fetchSavedUser()
        if  savedPerson != nil && savedPerson.data.token != ""{
            let home = UIStoryboard(name: "Board", bundle: .main)
                .instantiateViewController(withIdentifier: "HomePage") as! SSCustomTabBarViewController
            self.present(home, animated: true) {
                
            }
            debugPrint("session")
            
        }else{
            debugPrint("no session")
            
            pageControl?.numberOfPages = images.count
            startTimer()
            
        }
    }
    
    @objc func onMainViewClick(){
        self.alertControllerLang?.dismiss(animated: true, completion: {
            
        })
    }
    
    func startTimer(){
        timer = Timer.scheduledTimer(timeInterval: 3.0, target: self, selector: #selector(timerAction), userInfo: nil, repeats: true)
    }
    
    @objc func timerAction(){
        let desiredScrollPosition = (currentIndex < images.count - 1) ? currentIndex + 1 : 0
        collectionView?.scrollToItem(at: IndexPath(item: desiredScrollPosition, section: 0), at: .centeredHorizontally, animated: true)
    }
    
    
    @IBAction func btlLogin(_ sender: Any) {
        
        let loginVc = UIStoryboard(name: "Main", bundle: .main)
            .instantiateViewController(identifier: "LoginViewController") as LoginViewController
        self.present(loginVc, animated: true) {
            
        }
        
    }
    
    
    @IBAction func btnChangeLanguage(_ sender: Any) {
        
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
            
//            MOLH.setLanguageTo("ar")
//            MOLH.reset()
//            self.viewDidLoad()
            
            UserDefaults.standard.setValue("ar", forKey: Constants.SELECTED_LANG)

            
        })
        
        let english = UIAlertAction(title: "English", style: .default, handler: { (alert: UIAlertAction!) -> Void in
            //self.changeLanguage()
            
//            MOLH.setLanguageTo("en")
//                       MOLH.reset()
//            self.viewDidLoad()
            
            UserDefaults.standard.setValue("en", forKey: Constants.SELECTED_LANG)

        })
        
        //               alertController.addAction(deleteAction)
        alertControllerLang!.addAction(arabic)
        alertControllerLang!.addAction(english)
        //               alertController.addAction(maybeAction)
        
        self.present(alertControllerLang!, animated: true, completion: nil)
        
    }
    
    func changeLanguage(){
        if LocalizationSystem.sharedInstance.getLanguage() == "ar" {
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            print("en")
        } else {
            print("ar")
            LocalizationSystem.sharedInstance.setLanguage(languageCode: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        //        let vc = self.storyboard?.instantiateViewController(withIdentifier: "loginVc") as! MainViewController
        //        let appDlg = UIApplication.shared.delegate as? AppDelegate
        //        appDlg?.window?.rootViewController = vc
        viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        checkUserLogin()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
//        self.ref?.removeAllObservers()
        self.refButtonFlag?.removeAllObservers()
        
        
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        //timer?.invalidate()//stopping
        
    }
    
    
    @IBAction func btnRegister(_ sender: Any) {
        //self.view.makeToast("register")
        
        //        let registerVc = (self.storyboard?.instantiateViewController(identifier: "LoginViewController"))! as LoginViewController
        //        registerVc.flagRegister = true
        //        registerVc.modalTransitionStyle = .coverVertical
        //        self.present(registerVc, animated: true) {}
        
        
        
        let registerVc = (self.storyboard?.instantiateViewController(identifier: "RegisterViewController"))! as RegisterViewController
        registerVc.modalTransitionStyle = .coverVertical
        self.present(registerVc, animated: true) {}
        
        
        
    }
    
    
}


@available(iOS 13.0, *)
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SliderCell", for: indexPath) as! SliderCell
        
        cell.image = images[indexPath.item]
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        currentIndex = Int(scrollView.contentOffset.x / collectionView.frame.size.width)
        pageControl.currentPage = currentIndex
    }
    
    
    
    
    
}

