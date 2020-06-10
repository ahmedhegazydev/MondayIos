//
//  DataNotifi.swift
//  STask_IOS_APP
//
//  Created by Ahmed ElWa7sh on 5/25/20.
//  Copyright © 2020 Ahmed Hegazy . All rights reserved.
//

import Foundation
import ObjectMapper


class DataNotifi: Mappable{
    
   
    required init?(map: Map) {

    }
    
    
    var byName: String?
    var content: String?
    var boardId: String?
    
    
    // Mappable
       func mapping(map: Map) {
           byName    <- map["byName"]
           content         <- map["content"]
           boardId      <- map["boardId"]
      
       }
    
    
}
