//
//  ChangePasswordCodeView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 18/01/2024.
//

import Foundation
import SwiftUI

struct ChangePasswordCodeView: View {
    @State private var email = ""

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
                        .offset(y: -80)
                        .scaledToFit()
                        .frame(width: 50, height: 50)

                    Text("Verify Email")
                        .offset(y: -50)
                        .font(.title)
                        .fontWeight(.bold)
                        .padding(.top, 5)
                 
                    
                    HStack {
                       Spacer() // Pushes the text to the middle
                       Text("Enter The 6-Digit Verification Code Sent To Your Email")
                       .font(.system(size: 15))
                       .font(.caption)
                       .foregroundColor(.gray)
                       .multilineTextAlignment(.center) // Centers the text within the Text view
                       .frame(width: 210) // Set the fixed width for the container
                       .padding(.horizontal) // Ensures text doesn't touch the edges
                       .offset(y: -30)
                        
                        
                       Spacer() // Pushes the text to the middle
                   }
                    
                    HStack{
                        Spacer()
                        Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 34, height: 46)
                              .background(.white)
                              .overlay(
                                Rectangle()
                                  .inset(by: 0.50)
                                  .stroke(.black, lineWidth: 0.50)
                              )
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 34, height: 46)
                              .background(.white)
                              .overlay(
                                Rectangle()
                                  .inset(by: 0.50)
                                  .stroke(.black, lineWidth: 0.50)
                              )
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 34, height: 46)
                              .background(.white)
                              .overlay(
                                Rectangle()
                                  .inset(by: 0.50)
                                  .stroke(.black, lineWidth: 0.50)
                              )
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 34, height: 46)
                              .background(.white)
                              .overlay(
                                Rectangle()
                                  .inset(by: 0.50)
                                  .stroke(.black, lineWidth: 0.50)
                              )
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 34, height: 46)
                              .background(.white)
                              .overlay(
                                Rectangle()
                                  .inset(by: 0.50)
                                  .stroke(.black, lineWidth: 0.50)
                              )
                            Rectangle()
                              .foregroundColor(.clear)
                              .frame(width: 34, height: 46)
                              .background(.white)
                              .overlay(
                                Rectangle()
                                  .inset(by: 0.50)
                                  .stroke(.black, lineWidth: 0.50)
                              );
                        Spacer()
                    }
                    .offset(y: -25)
                    
                    NavigationLink(destination: ChangePasswordCreatePassView()){
                        
                        
                        Text("Verify")
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 9)
                            .background(Color.blue)
                            .cornerRadius(10)
                            .padding(.horizontal, 100)
                            .padding(.top, 15)

                    }
                            .offset(y: -20)
                           Spacer() // To push everything towards the center
                       }
                }
            }
}

struct ChangePasswordCodeView_Previews: PreviewProvider {
    static var previews: some View {
        ChangePasswordCodeView()
    }
}


