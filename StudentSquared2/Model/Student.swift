//
//  Student.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 06/02/2024.
//

import Foundation

struct Student: Identifiable, Codable {
    var id:String
    let studentID: Int
    let password:String
    let fullname:String
    let email: String
    let year: Int
    let course: String
    let userType: UserType
    var points: Int
    
    var initials: String {
        let formatter = PersonNameComponentsFormatter()
        if let components = formatter.personNameComponents(from: fullname) {
            formatter.style = .abbreviated
            return formatter.string(from: components)
        }
        return ""
    }
}

extension Student {
    static var MOCK_USER = Student(id: NSUUID().uuidString, studentID:1211104230, password: "111222", fullname: "Aisyah", email: "Aisyah@gmail.com", year: 2, course: "FCI", userType: .student, points: 0)
}
