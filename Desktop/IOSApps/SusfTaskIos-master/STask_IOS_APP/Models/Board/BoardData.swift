
import Foundation

// MARK: - Welcome
struct AllBoardsData: Codable {
    let message: String?
    let data: DataClassAllBoards?
    let successful: Bool?
}

// MARK: - DataClass
struct DataClassAllBoards: Codable {
    let BoardDataList: [BoardDataListModel]?

    enum CodingKeys: String, CodingKey {
        case BoardDataList
    }
}

// MARK: - BoardDataList
struct BoardDataListModel: Codable {
    var id: String?
    //let _id: String?
    var isPrivate: Bool?
    var name: String?
    //let description: JSONNull?
    var description: String?
    var color: String?
    var isArchive, isDelete: Bool?
    var createdAt: String?
    var nestedBoard: [NestedBoard]?

    enum CodingKeys: String, CodingKey {
        case id
        //case _id
        case isPrivate, name
        case description
        case color, isArchive, isDelete, createdAt, nestedBoard
    }
}

// MARK: - NestedBoard
struct NestedBoard: Codable {
    var isPrivate, isArchive, isDelete: Bool?
    var id, name, templateId, ownerId: String?
    var description: String?
//    var nestedBoard: [NestedBoardSub]?
    var nestedBoard: [NestedBoard]?

    enum CodingKeys: String, CodingKey {
        case isPrivate, isArchive, isDelete, id, name
        case templateId
        case ownerId
        case nestedBoard
        case description
    }
}

struct NestedBoardSub: Codable {
    let isPrivate, isArchive, isDelete: Bool?
    let id, name, templateId, ownerId, parentId: String?
    let description: String?
    
    enum CodingKeys: String, CodingKey {
        case isPrivate, isArchive, isDelete, id, name
        case templateId
        case ownerId
        case parentId
        case description
    }
}

// MARK: - Encode/decode helpers
class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
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
