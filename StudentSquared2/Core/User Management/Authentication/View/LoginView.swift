//
//  LoginView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 17/01/2024.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        
        ZStack{
            Rectangle()
                .foregroundColor(Color(red: 0.92, green: 0.90, blue: 0.97))
                .frame(width: 347, height: 333)
                .cornerRadius(20) // Add corner radius if needed
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
                .offset(y: -20) // Adjust the offset to position the Rectangle correctly
            
                VStack {
                    Spacer() // To push everything up
                    

                    Image("Logo") // Replace with your actual logo
                        .offset(y: -60)
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Text("Login Account")
                        .offset(y: -30)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 5)

                    TextField("Email address", text: $email)
                        
                        .padding(.leading, 10)
                        .frame(width: 219, height: 32.15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                        .offset(y: -30)

                        
                    SecureField("Password", text: $password)
                        .padding(.leading, 10)
                        .frame(width: 219, height: 32.15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                        .offset(y: -30)

                       
                    NavigationLink(destination: ChangePasswordRequestView()){
                        Text("Forgot Password?")
                            .foregroundColor(.blue)
                            .padding(.top, 15)
                            .offset(y: -30)
                            .offset(x:50)
                    }
                    

                     
                    Button(action: {
                        // Handle login logic here
                        print("Log User in")
                        Task {
                            try await viewModel.signIn(withEmail: email, password: password)
                        }
                    }) {
                        Text("Login")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 100)
                            .padding(.top, 15)
                            .offset(y: -30)

                    }
                           Spacer() // To push everything towards the center
                       }
                }
            }
        }

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
