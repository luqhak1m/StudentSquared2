//
//  Student.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 06/02/2024.
//

import Foundation

struct Staff: Identifiable, Codable {
    var id:String
    let staffID: Int
    let password:String
    let fullname:String
    let email: String
    let position: String
    let faculty: String
    let userType: UserType

    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension Staff {
    static var MOCK_USER = Staff(id: NSUUID().uuidString, staffID:201, password:"111111", fullname:"Saloma", email: "saloma@gmail.com", position: "Admin", faculty: "FCI", userType: .staff)
}
