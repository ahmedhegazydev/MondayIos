
import Foundation

// MARK: - Welcome
struct Nested: Codable {
    let message: String?
    let data: DataClassNested?
    let successful: Bool?
}

// MARK: - DataClass
struct DataClassNested: Codable {
    let BoardData: BoardDataNested?
    let dashBoardData: DashBoardData?
    
    enum CodingKeys: String, CodingKey {
        case BoardData
        case dashBoardData
    }
}

// MARK: - BoardData
struct BoardDataNested: Codable {
//    let _id: String?
    let nestedBoard: [NestedBoardH]?
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case nestedBoard
    }
}



struct NestedBoardH: Codable {
//    let _id: String?
    let id: String?
    let ownerName: String?
    let isPrivate, isArchive, isDelete: Bool?
    let name, templateId, ownerId: String?
    let tasksGroup: [TasksGroup]?
    let attachmentsGeneral: [Attachment]?
    let users: [UserHere]?
    let team: Team?
    let description: JSONNullH?
    
    
    enum CodingKeys: String, CodingKey {
        case id
//        case _id
        case isPrivate, isArchive, isDelete
        case name
        case templateId
        case ownerId
        case tasksGroup, attachmentsGeneral, users, team
        case description
        case ownerName
    }
}

// MARK: - Attachment
struct Attachment: Codable {
//    var _id: String?
    var isPrivate: Bool?
    var attachId: String?
    var attachName, attachKey: String?
    let users: [JSONAny]?
    //let byId: ID?
    var byId: String?
    //let byUserName: ByUserName
    var byUserName: String?
    var byShortName: String?
    var byUserImage: String?
    var byFullName: String?
    var addDate: String?
    var isDelete: Bool?
    
    //    init(attachId: String, attachName: String, attachKey: String,
    //         byUserName: String, byShortName: String, byUserImage: String, byFullName: String, addDate: String) {
    //
    //        self.attachId = attachId
    //        self.attachName = attachName
    //        self.attachKey = attachKey
    //        self.byUserName = byUserName
    //        self.byShortName = byShortName
    //        self.byShortName = byShortName
    //        self.byUserImage = byUserImage
    //        self.byFullName = byFullName
    //        self.addDate = addDate
    //
    //    }
    
    init() {
        
        self.attachId = ""
        self.attachName = ""
        self.attachKey = ""
        self.byUserName = ""
        self.byShortName = ""
        self.byShortName = ""
        self.byUserImage = ""
        self.byFullName = ""
        self.addDate = ""
//        self._id = ""
        self.byId = ""
        self.isDelete = false
        self.isPrivate = false;
        self.users = []
        
    }
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case isPrivate
        case attachId
        case attachName, attachKey, users
        case byId
        case byUserName, byShortName, byUserImage, byFullName, addDate
        case isDelete
    }
}


///flowTitle : string ,flowPercentage: number,flowStep : number,flowColor: string,progressColor: string,progressName: string
// MARK: - TasksGroup
struct TasksGroup: Codable {
    let id: String?
//    let _id: String?
    let name, templateId: String?
    
    
    let tasks: [TaskH]?
    
    enum CodingKeys: String, CodingKey {
        case id
//        case _id
        case name
        case templateId
        case tasks
        
        
    }
}

// MARK: - Task
struct TaskH: Codable {
    let id: String
    let isPrivate: Bool
    let addDate: String
    let progressValue: Int
    let isDelete: Bool
//    let _id: String
    let name: String
    let status: Status
    let startDate, dueDate: String
    //let ownerId: ID?
    let ownerId: String?
    let assignee: [UserHere]
    let attachments: [Attachment]
    let extraData: [JSONAny]
    let comments: [Comment]?
    let meetingUrl: String?
    let meetingTime: String?
    let flowTitle: String?
    let flowPercentage: Int?
    let flowStep: Int?
    let flowColor: String?
    let progressColor: String?
    let progressName: String?

    
    enum CodingKeys: String, CodingKey {
        case id
        case isPrivate, addDate, progressValue, isDelete
//        case _id
        case name, status, startDate, dueDate
        case ownerId
        case assignee, attachments, extraData, comments
        case meetingUrl
        case meetingTime
        case flowTitle
        case flowPercentage
        case flowStep
        case flowColor
        case progressColor
        case progressName

    }
}

// MARK: - User
public struct UserHere: Codable {
    let id: String?
//    let _id: String?
    let userName: String?
    let shortName: String?
    let userImage: String?
    let fullName: String?
    let name: String?
    
    enum CodingKeys: String, CodingKey {
        case id
//        case _id
        case userName, shortName, userImage, fullName, name
    }
}

// MARK: - Comment
struct Comment: Codable {
//    var _id: String?
    var addDate, updateDate: String?
    let isDelete: Bool?
    var commentId: String?
    var byId: String?
    var byUserName: String?
    var byShortName: String?
    var byUserImage: String?
    var byFullName: String?
    var commentData: String?
    var attachments: [Attachment]?
    let nestedComments: [Comment]?
    var usersmentionId: [UsersmentionID]?
    var deleteDate: String?
    init() {
//        self._id = ""
        self.addDate = ""
        self.updateDate = ""
        self.isDelete = false
        self.commentId = ""
        self.byId = ""
        self.byUserName = ""
        self.byShortName = ""
        self.byUserImage = ""
        self.byFullName = ""
        self.commentData = ""
        self.attachments = []
        self.nestedComments =  []
        self.usersmentionId =  []
        self.deleteDate = ""
        
    }
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case addDate, updateDate, isDelete
        case commentId
        case byId
        case byUserName, byShortName, byUserImage, byFullName, commentData, attachments, nestedComments
        case usersmentionId
        case deleteDate
    }
}

// MARK: - UsersmentionID
struct UsersmentionID: Codable {
    let id: String
//    let _id: String
    
    enum CodingKeys: String, CodingKey {
//        case _id
        case id
    }
}

// MARK: - Status
struct Status: Codable {
    let id, name, color: String?
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case color
    }
}

// MARK: - Team
struct Team: Codable {
    let id, teamName: String?
    //    enum CodingKeys: String, CodingKey {
    //           case id
    //           case teamName
    //       }
}

// MARK: - DashBoardData
struct DashBoardData: Codable {
    let noOfTasks: Int
    let taskStatusNo: [JSONAny]
    let noOfComments: Int
}

// MARK: - Encode/decode helpers

class JSONNullH: Codable, Hashable {
    
    public static func == (lhs: JSONNullH, rhs: JSONNullH) -> Bool {
        return true
    }
    
    public var hashValue: Int {
        return 0
    }
    
    public init() {}
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    let key: String
    
    required init?(intValue: Int) {
        return nil
    }
    
    required init?(stringValue: String) {
        key = stringValue
    }
    
    var intValue: Int? {
        return nil
    }
    
    var stringValue: String {
        return key
    }
}

class JSONAny: Codable {
    
    let value: Any
    
    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }
    
    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }
    
    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }
    
    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }
    
    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }
    
    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }
    
    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }
    
    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }
    
    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
