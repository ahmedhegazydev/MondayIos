
import Foundation

// MARK: - Welcome
struct InboxGetUserData: Codable {
    let message: String
    let data: [InboxGetUser]
    let successful: Bool
}

// MARK: - Datum
struct InboxGetUser: Codable {
    let isSeen: Bool
    let title, body: String
    let fromUser: FromUser
    let toUsers: [ToUser]
    let attachments: [JSONAny]
    let createdAt, id: String
    let createdAtTime: String

}

// MARK: - FromUser
struct FromUser: Codable {
    let id, name, userName, shortName: String
    let userImage: String
}

// MARK: - ToUser
struct ToUser: Codable {
    let id: String
//    let _id: String
    let name: String
    let shortName,userImage : String
    enum CodingKeys: String, CodingKey {
        case id
//        case _id
        case name
        case shortName,userImage
    }
}

