//
//  Inbox.swift
//  ImageSlider
//
//  Created by A on 4/11/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//

import Foundation

struct Inbox {
    
    var users: String = ""
    var title: String = ""
    var body: String = ""
    
    init(title: String, body: String) {
        self.title = title;
        self.body = body
    }
    
    
    init(title: String, body: String, userIds: String) {
        self.title = title;
        self.body = body
        self.users = userIds
    }
    
    
}
