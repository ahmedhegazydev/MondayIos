//
//  Utils.swift
//  ImageSlider
//
//  Created by A on 4/1/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//
import Foundation
import UIKit
import LetterAvatarKit

@available(iOS 13.0, *)
class  Utils {
    
    
    static func isValidEmail(email:String?) -> Bool {
        
        guard email != nil else { return false }
        
        let regEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let pred = NSPredicate(format:"SELF MATCHES %@", regEx)
        return pred.evaluate(with: email)
    }
    
    static  func fetchSavedUser() -> UserData{
        let defaultUser = UserData()
        if let savedPerson =
            UserDefaults.standard.object(forKey: Constants.SAVED_USER) as? Data {
            let decoder = JSONDecoder()
            if let loadedPerson = try? decoder.decode(UserData.self, from: savedPerson) {
                //                       debugPrint(userData.data.user.email)
                //                       debugPrint(userData.data.user.firstName)
                //                       debugPrint(userData.data.user.id)
                //                       debugPrint(userData.data.user.mobile)
                //                       debugPrint(userData.data.user.lastName)
                return loadedPerson
                
            }
        }
        return defaultUser;
    }
    
    static  func fetchSavedNestedBoard() -> NestedBoardH?{
        if let savedNested =
            UserDefaults.standard.object(forKey: Constants.SELECTED_NESTED_BOARD) as? Data {
            let decoder = JSONDecoder()
            if let savedNestedBoard = try? decoder.decode(NestedBoardH.self, from: savedNested) {
                return savedNestedBoard
            }
        }
        return nil;
    }
    
    
    static func logout(viewController: UIViewController?){
        UserDefaults.standard.removeObject(forKey: Constants.SAVED_USER)
        let login = UIStoryboard(name: "Main", bundle: .main).instantiateViewController(withIdentifier: "loginVc") as! MainViewController
        login.modalPresentationStyle = .fullScreen
        login.modalTransitionStyle = .coverVertical
        
        viewController!.present(login, animated: true) {
            
        }
    }
    
    static func pureDate(dateBefore: String) -> String{
        //var dateBefore = task?.dueDate
        print("dategogo \(dateBefore)")
        var dateAfter: String = ""
        if dateBefore != nil {
            var delimiter = "T"
            dateAfter = dateBefore.components(separatedBy: delimiter)[0]
        }
        return dateAfter
    }
    
    static func pureDateTime(dateBefore: String) -> String{
        return pureDate(dateBefore: dateBefore)
            +
            "  "
            + pureTime(dateBefore: dateBefore)
    }
    
    static func pureTime(dateBefore: String) -> String{
        var dateAfter: String = ""
        print("dateBef= \(dateBefore)")
        if dateBefore != nil && !dateBefore.isEmpty {
            var delimiter = "T"
            dateAfter = dateBefore.components(separatedBy: delimiter)[1]
            dateAfter = dateAfter.components(separatedBy: ".")[0]
            dateAfter = dateAfter.components(separatedBy: ":")[0] + ":" +
                dateAfter.components(separatedBy: ":")[1]
            print("dateAfter = \(dateAfter)")
            //2020-04-19T18:49:04.330Z
            return convert24To12(dateAfter)
//            return dateAfter
        }
        return dateAfter
    }
    
    
    static func convert24To12(_ dateAsString: String?) -> String{
        let Date12: String = ""
        if  dateAsString != nil && dateAsString != ""{
        print("fofosd = \(dateAsString)")
        //let dateAsString = "13:15"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm:ss"
//        dateFormatter.dateFormat = "HH:mm"

//        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
            let date = dateFormatter.date(from: dateAsString!)
        dateFormatter.dateFormat = "hh:mm:ss a"
//        dateFormatter.dateFormat = "hh:mm a"

        
        let Date12 = dateFormatter.string(from: date!)
        print("12 hour formatted Date:",Date12)
        }
        return Date12
    }
    
    static func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt64 = 0
        Scanner(string: cString).scanHexInt64(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    public static func letterAvatarImage(chars: String) -> UIImage{
        let size = 100
        return LetterAvatarMaker()
            .setCircle(true)
            .setUsername(chars)
            .setBorderWidth(2.0)
            .setBorderColor(Utils.hexStringToUIColor(hex: Constants.Colors.GREEN))
            .setBackgroundColors([ Utils.hexStringToUIColor(hex: Constants.Colors.GREEN),Utils.hexStringToUIColor(hex: Constants.Colors.GREEN) ])
            .setLettersColor(.white)
            .setSize(CGSize(width: size, height: size))
            .build()!
        
    }
    
}
