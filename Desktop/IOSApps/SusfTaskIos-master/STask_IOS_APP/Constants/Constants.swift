//
//  Constants.swift
//  ImageSlider
//
//  Created by A on 4/1/20.
//  Copyright © 2020 Eslam Shaker . All rights reserved.
//
import Foundation

//admin@susftask.com
//P@ssw0rd007008

struct Constants {
//    static let BASE_URL = "https://tmms2020.herokuapp.com/";
    
    init() {
    
    }
    
    
    static var BASE_URL :String  = getSwitchedBaseUrl()
    
    
    static func getSwitchedBaseUrl() -> String{
        let defaults = UserDefaults.standard
        let url: String = defaults.value(forKey: Constants.SELECTED_BASE_URL) as! String
        if url != nil{
            print("Selected base url = \(url)")
            //return url
            return "http://wayak.org/"
        }else{
            print("nil gogo")
        }
        return "http://wayak.org/"
    }
    
    static let PRIVACY = "https://susftask.com/app/policy"
    
    static let SELECTED_BASE_URL = "SELECTED_BASE_URL"
    static let FCM_TOKEN =  "FCM_TOKEN"
    static let DATA_BOARD_ID =  "DATA_BOARD_ID"
    static let FROM_ALL_BOARDS_OR_NOTIFI = "FROM_ALL_BOARDS_OR_NOTIFI"
    static let SELECTED_LANG = "SELECTED_LANG"
    
    class Uplaoding {
        static let END_POINT_UPLOAD_FILE = "file/file"
        static let END_POINT_DOWNLOAD_FILE = "file/file/"
    }
    
    class Ends {
        static let END_POINT_NOTIFICATIONS = "task/userTaskNotification";
        static let END_POINT_LOGIN = "user/signin";
        static let END_POINT_ALL_BOARDS = "board"

        static let END_POINT_CHANGE_PASSWORD_URL = BASE_URL +
                   "user/change-password";
//        static let END_POINT_NESTED = BASE_URL + "board/nested";
        static let END_POINT_NESTED = "board/nested"
        static let END_POINT_ADD_COMMENT = "task/comment"
        static let END_POINT_COMMENTS_URL = "task/comment/"
        static let END_POINT_ADD_ATTACH_GENERAL = "task/attachgeneral/";
        static let END_POINT_NOTIFICATION_URL = "task/userTaskNotification";
        static let END_POINT_SUBCOMMENTS_URL =  "task/getcommentsub/";
        static let END_POINT_ADD_SUB_COMMENT = "task/commentsub";
        static let END_POINT_DELETE_SUB_COMMENT = "task/commentsub/";
        static let END_POINT_GET_ALL_USERS = "​user/allusers";
        static let END_POINT_USER_FORGOT_PASS = "​user/forgot-password";

        
        static let END_POINT_SET_NOTI_AS_SEEN = "​task/notificationSeen/";
        
        
        static let END_POINT_DEL_ATTACHMENT_GENERAL = "task/deleteattachgeneral/";
        static let END_POINT_REGISTER = "user/register";

        static let END_POINT_GET_ALL_ATTACHMENTS = "task/attachgeneral";
    }
    
    class Inbox{
        static let END_GET_MAIL = "mail"
        static let END_GET_MAIL_SENT = "mail/sent"
        static let END_POST_MAIL = "mail"
        static let END_PUT_MAIL = "mail/"
    }
    
    
    static let SAVED_USER = "SavedPerson"
    static let SELECTED_NESTED_BOARD = "SELECTED_NESTED_BOARD"
    static let SAVED_ALL_USERS = "SAVED_ALL_USERS"
    static let SAVED_USER_NOTIFI = "SAVED_USER_NOTIFI"
    
    static let SAVED_USER_TASK = "SAVED_USER_TASK"

    static let INBOX_SELECTED_RECIPIENTS = "INBOX_SELECTED_RECIPIENTS"
    static let SAVED_ATTACHMENTS_TO_NESTED = "SAVED_ATTACHMENTS_TO_NESTED"
    static let APP_NAME = "SUSF TASK"
//    static let APP_NAME = "Monday"
    
    
    
    class Colors{
        static let GREEN = "#189276"
    }
    
}
