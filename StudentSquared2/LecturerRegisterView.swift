//
//  LecturerRegisterView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 18/01/2024.
//

import Foundation
import SwiftUI

struct LecturerRegisterView: View {
    var body: some View {
        RegisterPage(firstPlaceholder: "Position", secondPlaceholder: "Faculty", title: "Lecturer \nRegistration", actionTitle: "Register") {
            // Define the action for registering an admin
        }
    }
}

struct LecturerRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        LecturerRegisterView()
    }
}
// ... Implement previews for AdminRegistrationView
