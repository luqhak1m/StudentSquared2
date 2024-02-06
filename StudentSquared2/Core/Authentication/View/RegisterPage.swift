//
//  RegisterPage.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 17/01/2024.
//

import Foundation
import SwiftUI

struct RegisterPage: View {
    @State private var email = ""
    @State private var id = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var fullname = ""
    @State private var year = ""
    @State private var course = ""
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: AuthViewModel
    
    /*var firstPlaceholder: String
    var secondPlaceholder: String
    var title: String
    var actionTitle: String
    var action: () -> Void*/
    
    var title: String
    var actionTitle: String

    var body: some View {
        ZStack {
            Rectangle()
                .foregroundColor(Color(red: 0.92, green: 0.90, blue: 0.97))
                .frame(width: 347, height: 600)
                .cornerRadius(20) // Add corner radius if needed
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
                .offset(y: 25) // Adjust the offset to position the Rectangle correctly
            // Background and other common UI elements ...

            VStack {
                Spacer() // To push everything up
                

                Image("Logo") // Replace with your actual logo
                    .offset(y: -35)
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                
                HStack{
                    Spacer()
                    Text(title)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                        .offset(y: -10)
                        .multilineTextAlignment(.center)
                    Spacer()
                }
                

                // Logo, Title, and TextFields ...
                CustomTextField(placeholder: "Student ID", text: $id, isSecure: false)
                CustomTextField(placeholder: "Password", text: $password, isSecure: false)
                CustomTextField(placeholder: "Confirm Password", text: $confirmPassword, isSecure: false)
                CustomTextField(placeholder: "Name", text: $fullname, isSecure: false)
                CustomTextField(placeholder: "Email Address", text: $email, isSecure: false)
                CustomTextField(placeholder: "Year", text: $year, isSecure: false)
                CustomTextField(placeholder: "Course", text: $course, isSecure: false)
                HStack {
                   Spacer() // Pushes the text to the middle
                   Text("Password should be 6 minimum characters, at least 1 number, 1 special character, no Caps Lock")
                   .font(.system(size: 9))
                   .font(.caption)
                   .foregroundColor(.gray)
                   .multilineTextAlignment(.center) // Centers the text within the Text view
                   .frame(width: 210) // Set the fixed width for the container
                   .padding(.horizontal) // Ensures text doesn't touch the edges
                   Spacer() // Pushes the text to the middle
               }
                
                // Register/Action button
                Button{
                    Task {
                       try await viewModel.createUser(withEmail: email, password: password, fullname: fullname, userType: .student, studentID: Int(id), year: Int(year), course: course, staffID: nil, position: nil, faculty: nil)
                    }
                } label: {
                    HStack {
                        Text("Register")
                            .foregroundColor(.white)
                            .padding(.vertical, 9)
                            .frame(width: 218, height: 45)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .offset(y:-10)
                    }
                    .padding(.horizontal, 100)
                    .padding(.top, 15)
                }

                Spacer() // To push everything towards the center
            }
        }
    }
}

struct RegisterPage_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPage(title: "Registration", actionTitle: "Register")
    }
}
