//
//  UtilsAlert.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation
import UIKit
import CDAlertView
import JSSAlertView


class UtilsAlert {
    
    
    static func  showError(message: String){
        let alert = CDAlertView(title: Constants.APP_NAME, message: message, type: .error)
        let doneAction = CDAlertViewAction(title: "Okay")
        alert.add(action: doneAction)
        alert.show()
        
    }
    
    static func  showSuccess(message: String){
        let alert = CDAlertView(title: Constants.APP_NAME, message: message, type: .success)
        let doneAction = CDAlertViewAction(title: "Okay")
        alert.add(action: doneAction)
        alert.show()
        
    }
    
    
    static func  showInfo(message: String){
        let alert = CDAlertView(title: Constants.APP_NAME, message: message, type: .notification)
        let doneAction = CDAlertViewAction(title: "Okay")
        alert.add(action: doneAction)
        alert.show()
        
    }
    
    static func  showInfo2(_ vc: UIViewController?, _ title: String?, _ text: String?){
        var alertview = JSSAlertView().show(
            vc!,
            title: title!,
        text: text,
        buttonText: "Ok"
        //color: UIColorFromHex(0x9b59b6, alpha: 1)
        )
        //alertview.addAction(myCallback) // Method to run after dismissal
        alertview.setTitleFont("ClearSans-Bold") // Title font
        alertview.setTextFont("ClearSans") // Alert body text font
        alertview.setButtonFont("ClearSans-Light") // Button text font
        //alertview.setTextTheme(.light)
        alertview.setTextTheme(.dark)
        
        
    }
    
    
}
