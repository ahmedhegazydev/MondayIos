// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? newJSONDecoder().decode(Welcome.self, from: jsonData)

import Foundation

// MARK: - Welcome
struct Reply: Codable {
    let message: String
    let data: DataElementReply
    let successful: Bool
}

// MARK: - DataElement
struct DataElementReply: Codable {
//    let _id: String?
    let addDate, updateDate: String?
    let  addDateTime: String?

    let isDelete: Bool?
    let commentId: String?
    //let byId: ID?
    let byId: String?
    //let byUserName: ByUserName?
    let byUserName: String?
    let byShortName: String?
    let byUserImage: String?
    let byFullName: String?
    let commentData: String?
    let attachments: [Attachment]?
    let nestedComments: [Comment]?
    let usersmentionId: [UsersmentionID]?
    let deleteDate: String?
    let deleteDateTime: String?

    enum CodingKeys: String, CodingKey {
//        case _id
        case addDate, updateDate, isDelete
        case addDateTime

        case commentId
        case byId
        case byUserName, byShortName, byUserImage, byFullName, commentData, attachments, nestedComments
        case usersmentionId
        case deleteDate
        case deleteDateTime

    }
}


