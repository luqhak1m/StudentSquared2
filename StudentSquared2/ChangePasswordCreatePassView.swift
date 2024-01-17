//
//  ChangePasswordCreatePassView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 18/01/2024.
//

import Foundation
import SwiftUI

struct ChangePasswordCreatePassView: View {
    @State private var oldPass = ""
    @State private var newPass = ""
    @State private var confirmNewPass = ""

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
                        .offset(y: -53)
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Text("Change Password")
                        .offset(y: -40)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                
                    TextField("Old Password", text: $oldPass)
                        
                        .padding(.leading, 10)
                        .frame(width: 219, height: 32.15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                        .offset(y: -40)
                    
                    TextField("New Password", text: $newPass)
                        
                        .padding(.leading, 10)
                        .frame(width: 219, height: 32.15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                        .offset(y: -40)
                    
                    TextField("Confirm New Password", text: $confirmNewPass)
                        
                        .padding(.leading, 10)
                        .frame(width: 219, height: 32.15)
                        .background(Color(.secondarySystemBackground))
                        .cornerRadius(10)
                        .padding(.horizontal, 100)
                        .offset(y: -40)
                    
                    HStack {
                       Spacer() // Pushes the text to the middle
                       Text("Password should be 8 minimum characters, at least 1 number, 1 special character, 1 Caps Lock ")
                       .font(.system(size: 9))
                       .font(.caption)
                       .foregroundColor(.gray)
                       .multilineTextAlignment(.center) // Centers the text within the Text view
                       .frame(width: 210) // Set the fixed width for the container
                       .padding(.horizontal) // Ensures text doesn't touch the edges
                       .offset(y: -30)
                       Spacer() // Pushes the text to the middle
                   }

                    
                    NavigationLink(destination: LoginView()){
                        
                        
                        Text("Send")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 100)
                            .padding(.top, 15)

                    }
                            .offset(y: -30)
                           Spacer() // To push everything towards the center
                       }
                }
            }
}

struct ChangePasswordCreatePassView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordCreatePassView()
    }
}


