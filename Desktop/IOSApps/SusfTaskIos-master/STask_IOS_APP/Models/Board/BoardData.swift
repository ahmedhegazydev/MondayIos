
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
    let id: String?
    //let _id: String?
    let isPrivate: Bool?
    let name: String?
    //let description: JSONNull?
    let description: String?
    let color: String?
    let isArchive, isDelete: Bool?
    let createdAt: String?
    let nestedBoard: [NestedBoard]?

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
    let isPrivate, isArchive, isDelete: Bool?
    let id, name, templateId, ownerId: String?
    //let description: JSONNull?
    let description: String?

    
    enum CodingKeys: String, CodingKey {
        case isPrivate, isArchive, isDelete, id, name
        case templateId
        case ownerId
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
