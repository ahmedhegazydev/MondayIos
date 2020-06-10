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
    let email, mobile, fullName, shortName: String?
    let userName: String?
    let userImage: String?
    let id: String?
    let zoomAccount: String?
}


extension UserAll: SearchableData {
    
    public var searchValue: String{
        //return email!
        return fullName!
    }
}
