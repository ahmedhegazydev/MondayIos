// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation
import HSSearchable

// MARK: - Welcome
struct UserDataAll: Codable {
    let message: String
    let data: [UserAll]?
    let successful: Bool
}

// MARK: - Datum
public struct UserAll: Codable {
    var email, mobile, fullName, shortName: String?
    var userName: String?
    var userImage: String?
    var id: String?
    var zoomAccount: String?
    
    
    init() {
        self.email = ""
         self.mobile = ""
         self.fullName = ""
        self.shortName = ""
        self.userName = ""
        self.userImage = ""
        self.id = ""
        self.zoomAccount = ""
    }
    
}


extension UserAll: SearchableData {
    
    public var searchValue: String{
        //return email!
        return fullName!
    }
}
