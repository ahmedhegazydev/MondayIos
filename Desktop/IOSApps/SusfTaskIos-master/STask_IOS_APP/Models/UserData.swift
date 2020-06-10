
import Foundation

// MARK: - Welcome
struct UserData: Codable {
    let message: String
    let data: DataClass
    let successful: Bool
    
    
    init() {
        self.message = ""
        self.data = DataClass()
        self.successful = false
        
    }
    
}

// MARK: - DataClass
struct DataClass: Codable {
    let token: String
    let user: User
    
    init() {
        self.token = ""
        self.user = User()
    }
}

// MARK: - User
struct User: Codable {
    let id, firstName, lastName, shortName: String
    var userImage: String
    let userName, mobile, email: String
    let mustChangePassword: Bool
    let tenantID: Int
    let ssot: String

    init() {
        
        self.id = ""
        self.firstName = ""
        self.lastName = ""
        self.shortName = ""
        self.userImage = ""
        self.userName = ""
        self.mobile = ""
        self.email = ""
        self.mustChangePassword = true;
        self.tenantID = 329
        self.ssot = ""
       
    }
    
    
    enum CodingKeys: String, CodingKey {
        case id, firstName, lastName, shortName, userImage, userName, mobile, email, mustChangePassword
        case tenantID = "tenantId"
        case ssot
    }
}
