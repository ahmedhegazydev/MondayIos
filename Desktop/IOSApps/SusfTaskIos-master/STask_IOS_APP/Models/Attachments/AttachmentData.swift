//
//  AttachmentData.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 5/12/20.
//  Copyright © 2020 Ahmed Hegazy . All rights reserved.
//

import Foundation
import ObjectMapper


struct AttachmentData: Mappable {
    var isPrivate: Bool?
    var isDelete: Bool?
//    var _id: String?
    var attachId: String?
    var attachName: String?
    var attachKey: String?
    var users:[String]?
    var byId: String?
    var byUserName: String?
    var byShortName: String?
    var byUserImage: String?
    var byFullName: String?
    
    var addDate: String?
   var addDateTime: String?

    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        
        isPrivate <- map["isPrivate"]
        isDelete <- map["isDelete"]
//        _id <- map["_id"]
        attachId <- map["attachId"]
        attachName <- map["attachName"]
        attachKey <- map["attachKey"]
        users <- map["users"]
        byId <- map["byId"]
        byUserName <- map["byUserName"]
        byShortName <- map["byShortName"]
        byUserImage <- map["byUserImage"]
        byFullName <- map["byFullName"]
        addDate <- map["addDate"]
        addDateTime <- map["addDateTime"]

        
        
    }
    
    
}
