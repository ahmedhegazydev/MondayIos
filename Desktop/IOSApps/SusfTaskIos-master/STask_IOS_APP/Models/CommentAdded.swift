import Foundation

// MARK: - Welcome
struct CommentAddData: Codable {
//    let data: DataClassCommentAddData
    let data: Comment
    let message: String
    let successful: Bool
}

// MARK: - DataClass
//struct DataClassCommentAddData: Codable {
//    let byFullName, byId, commentData, addDate: String?
//    let byUserName, byShortName, taskId, commentId: String?
//    let attachments: [Attachment]?
//    let usersmentionID: [JSONAny]?
//    let byUserImage: String?
//
//    enum CodingKeys: String, CodingKey {
//        case byFullName
//        case byId
//        case commentData, addDate, byUserName, byShortName
//        case taskId
//        case commentId
//        case attachments
//        case usersmentionID
//        case byUserImage
//    }
//}
