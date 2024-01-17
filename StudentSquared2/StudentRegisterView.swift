//
//  StudentRegisterView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 18/01/2024.
//

import Foundation
import SwiftUI

struct StudentRegisterView: View {
    var body: some View {
        RegisterPage(firstPlaceholder: "Year", secondPlaceholder: "Course", title: "Student \nRegistration", actionTitle: "Register") {
            // Define the action for registering an admin
        }
    }
}

struct StudentRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        StudentRegisterView()
    }
}
// ... Implement previews for AdminRegistrationView
