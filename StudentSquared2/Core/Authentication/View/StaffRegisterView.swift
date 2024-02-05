//
//  StaffRegisterView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 18/01/2024.
//

import Foundation
import SwiftUI

struct StaffRegisterView: View {
    var body: some View {
        RegisterPage(firstPlaceholder: "IDK", secondPlaceholder: "IDK", title: "Staff \nRegistration", actionTitle: "Register") {
            // Define the action for registering an admin
        }
    }
}

struct StaffRegisterView_Previews: PreviewProvider {
    static var previews: some View {
        StaffRegisterView()
    }
}
// ... Implement previews for AdminRegistrationView
