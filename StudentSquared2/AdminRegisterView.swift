//
//  AdminRegisterView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 17/01/2024.
//

import Foundation
import SwiftUI

struct AdminRegisterView: View {
    var body: some View {
        RegisterPage(firstPlaceholder: "IDK", secondPlaceholder: "IDK", title: "Admin \nRegistration", actionTitle: "Register") {
            // Define the action for registering an admin
        }
    }
}

struct AdminRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        AdminRegisterView()
    }
}
// ... Implement previews for AdminRegistrationView
