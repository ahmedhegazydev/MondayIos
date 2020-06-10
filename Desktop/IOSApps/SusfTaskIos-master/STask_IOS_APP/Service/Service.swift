//
//  Service.swift
//  ImageSlider
//
//  Created by A on 4/2/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class Service{
    
    fileprivate var baseUrl = ""
    typealias CallbackLogin = (userData :UserData?, statuts : Bool, message: String)
    var callLogin: CallbackLogin?
    
    
    init(baseUrl: String) {
        self.baseUrl = baseUrl
    }
    
//    func loginUser(endPoint: String, email: String, password: String){
//        let headers: HTTPHeaders = [
//            //.acceptLanguage("ar"),
//            .accept("application/json")
//        ]
//        let parameters: [String: Any] = [
//            //            "email": "admin@admin.com",
//            //            "password" : "admin123",
//
//            //            "email": "\(self.etEnterEmail.text!)",
//            //            "password" : "\(self.etEnterPassword.text!)",
//            "email": "\(email)",
//            "password" : "\(password)",
//
//            "deviceId" : "23232323232",
//        ]
//        AF.request(self.baseUrl,method: .post, parameters: parameters, headers: headers)
//            //.response { response in
//            .responseJSON { response in
//                switch response.result {
//                case .success(let data):
//                    let swiftyData = JSON(response.value)
//                    let successful = swiftyData["successful"].intValue
//                    debugPrint("state \(successful)")
//                    if successful == 1{
//                        let message = swiftyData["message"].stringValue
//                        debugPrint(message)
//                        guard let data = response.data else { return }
//                        do {
//                            let decoder = JSONDecoder()
//                            let userData = try decoder.decode(UserData.self, from: data)
//
//
//                        } catch let error {
//                            print(error)
//                        }
//
//                    }else{
//                        let errorMessages: String =  swiftyData["errorMessages"][0].stringValue
//                        debugPrint("error \(errorMessages)")
//
//
//                    }
//
//                case .failure(let error):
//                    debugPrint( "Failure: \(error.localizedDescription)")
//                    self.callLogin(nil, false, error.localizedDescription)
//
//                }
//        }
//
//    }
    
    
}
