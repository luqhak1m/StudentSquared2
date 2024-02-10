import Foundation

enum UserType: String, Codable {
    case student
    case staff
}

struct User: Identifiable, Codable {
    let id: String
    let fullname: String
    let email: String
    let userType: UserType
    
    init(id: String, fullname: String, email: String, userType: UserType) {
        self.id = id
        self.fullname = fullname
        self.email = email
        self.userType = userType
    }
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension User {
    static var MOCK_USER = User(id: UUID().uuidString, fullname: "Kobe Bryant", email: "test@gmail.com", userType: .staff)
}

