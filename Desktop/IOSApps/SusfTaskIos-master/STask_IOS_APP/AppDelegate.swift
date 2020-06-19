//
//  AppDelegate.swift
//  Seyanah
//
//  Created by Peter Bassem on 8/30/19.
//  Copyright © 2019 Peter Bassem - Beyond Technology. All rights reserved.
//

import Siren
import UIKit
import Firebase
import UserNotifications
import FirebaseMessaging
import SSCustomTabbar


@UIApplicationMain
class AppDelegate2: UIResponder, UIApplicationDelegate, MessagingDelegate {
    var fcmToken: String?
    var window: UIWindow?
    let gcmMessageIDKey = "gcm.message_id"
    
    var rateWorkerType: String?
    var requestKey: String?
    var orderId: String?
    
    //SHOW RATE FOR USER
    lazy var backgroundView: UIView = {
        let view = UIView()
        view.frame = UIApplication.shared.keyWindow!.frame
        view.backgroundColor = UIColor(red: 0/255, green: 0/255, blue: 0/255, alpha: 0.30)
        return view
    }()
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        UserDefaults.standard.setValue("ar", forKey: Constants.SELECTED_LANG)
        UNUserNotificationCenter.current().requestAuthorization(options: [.badge, .alert, .sound], completionHandler: {(granted, error) in
        })
        application.registerForRemoteNotifications()
        
        Messaging.messaging().delegate = self
        
        if #available(iOS 10.0, *) {
            // For iOS 10 display notification (sent via APNS)
            UNUserNotificationCenter.current().delegate = self
            
            let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
            UNUserNotificationCenter.current().requestAuthorization(
                options: authOptions,
                completionHandler: {_, _ in })
        } else {
            let settings: UIUserNotificationSettings =
                UIUserNotificationSettings(types: [.alert, .badge, .sound], categories: nil)
            application.registerUserNotificationSettings(settings)
        }
        
        UNUserNotificationCenter.current().getNotificationSettings(){ (setttings) in
            
            switch setttings.soundSetting {
            case .enabled:
                print("enabled sound")
            case .disabled:
                print("not allowed notifications")
                
            case .notSupported:
                print("something went wrong here")
            @unknown default:
                fatalError()
            }
        }
        
        
        application.isIdleTimerDisabled = true
        
        
        //        UserDefaults.standard.setValue("BOR388347926117524", forKey: Constants.DATA_BOARD_ID)
        //        self.window?.rootViewController?.dismiss(animated: true, completion: nil)
        //
        //                   let storyboard = UIStoryboard(name: "Board", bundle: .main)
        //                   let vc = storyboard.instantiateViewController(identifier: "HomePage") as! SSCustomTabBarViewController
        //        vc.selectedIndex = 0
        //
        //
        //                   self.window = UIWindow(frame: UIScreen.main.bounds)
        //                   self.window?.rootViewController = vc
        //                   self.window?.makeKeyAndVisible()
        
        
        
        Siren.shared.wail() // Line 2

        
        return true
    }
    
    
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        
                UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        
                UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        print("Firebase registration token: \(fcmToken)")
        
        InstanceID.instanceID().instanceID { (result, error) in
            if let error = error {
                print("Error fetching remote instance ID: \(error)")
            } else if let result = result {
                print("Remote instance ID token: \(result.token)")
                self.fcmToken=result.token
                //                self.instanceIDTokenMessage.text  = "Remote InstanceID token: \(result.token)"
            }
        }
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
    
        
        application.applicationIconBadgeNumber = application.applicationIconBadgeNumber + 1
        
        
        completionHandler(UIBackgroundFetchResult.newData)
        print(userInfo)
        openNotification(userInfo)
    }
}

extension AppDelegate2 {
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let token = deviceToken.map { String(format: "%02.2hhx", $0) }.joined()
        print("token: \(token)")
        Messaging.messaging().apnsToken = deviceToken as Data
        
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNs registration failed: \(error)")
        print("failed")
    }
    
    func application(_ application: UIApplication, handleActionWithIdentifier identifier: String?, forRemoteNotification userInfo: [AnyHashable : Any], withResponseInfo responseInfo: [AnyHashable : Any], completionHandler: @escaping () -> Void) {
        print("identifier = \(String(describing: identifier))")
    }
}

@available(iOS 10, *)
extension AppDelegate2 : UNUserNotificationCenterDelegate {
    // Receive displayed notifications for iOS 10 devices.
    
    fileprivate func openNotification(_ userInfo: [AnyHashable : Any]) {
        // Print full message.
        if let boardId = userInfo["boardId"] as? String {
            UserDefaults.standard.setValue(boardId, forKey: Constants.DATA_BOARD_ID)
            self.window?.rootViewController?.dismiss(animated: true, completion: nil)
            
            let storyboard = UIStoryboard(name: "Board", bundle: .main)
            let vc = storyboard.instantiateViewController(identifier: "HomePage") as! SSCustomTabBarViewController
            vc.selectedIndex = 0
            
            
            self.window = UIWindow(frame: UIScreen.main.bounds)
            self.window?.rootViewController = vc
            self.window?.makeKeyAndVisible()
            
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        // With swizzling disabled you must let Messaging know about the message, for Analytics
        Messaging.messaging().appDidReceiveMessage(userInfo)
        
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        
        // Change this to your preferred presentation option
        completionHandler([.alert, .sound, .badge])
    }
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo as! [String: Any]
        print("received remote notification")
        // Print message ID.
        if let messageID = userInfo[gcmMessageIDKey] {
            print("Message ID: \(messageID)")
        }
        // Print full message.
        print(userInfo)
        
        //        guard let orderId = userInfo["type"] as? String else { return }
        //        self.orderId = orderId
        
        UIApplication.shared.applicationIconBadgeNumber = UIApplication.shared.applicationIconBadgeNumber + 1
        
        let application = UIApplication.shared
        if application.applicationState == .active {
            openNotification(userInfo)
        } else if application.applicationState == .inactive || application.applicationState == .background {
            openNotification(userInfo)
        }
        completionHandler()
    }
    
    @available(iOS 10.0, *)
    func userNotificationCenter(center: UNUserNotificationCenter, willPresentNotification notification: UNNotification, withCompletionHandler completionHandler: (UNNotificationPresentationOptions) -> Void) {
        //Handle the notification
        completionHandler([.alert, .sound, .badge])
    }
}


