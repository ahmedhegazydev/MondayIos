
import Foundation

// MARK: - Welcome
struct NotificationData: Codable {
    let message: String?
    let data: DataClassNotifi?
    let successful: Bool?
}

// MARK: - DataClass
struct DataClassNotifi: Codable {
    let notification: [Notification]?
    let tasks: [Task]?
}

// MARK: - Notification
struct Notification: Codable {
    let isSeen: Bool?
    let id, msg, nType, byName: String?
    let paramStr: [String]?
    let time: String?
}

// MARK: - Task
struct Task: Codable {
    let id, boardId, taskId, name: String?
    let dueDate: String?

    enum CodingKeys: String, CodingKey {
        case id
        case boardId
        case taskId
        case name, dueDate
    }
}
