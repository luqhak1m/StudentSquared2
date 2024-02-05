//
//  ContentView.swift
//  StudentSquared
//
//  Created by Luqman Hakim on 15/01/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                StudentProfileView()
            } else {
                NavigationView {
                    ZStack {
                        
                        Color(.white)
                            .ignoresSafeArea()
                        VStack {
                            Image("Logo") // Replace "logo" with your actual logo image name
                                .resizable()
                                .scaledToFit()
                                .frame(width: 100, height: 100)
                            Text("Student\nSquared")
                                .font(Font.custom("Outfit", size: 43))
                                .lineSpacing(1)
                            
                            NavigationLink(destination: LoginView()) {
                                Text("Login")
                                    .foregroundColor(.black)
                                    .frame(width: 210, height: 44)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                            }
                            
                            NavigationLink(destination: RegisterOptions()) {
                                Text("Register")
                                    .foregroundColor(.black)
                                    .frame(width: 210, height: 44)
                                    .background(Color.white)
                                    .cornerRadius(12)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 12)
                                            .stroke(Color.black, lineWidth: 0.5)
                                    )
                                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                            }
                    
                            // Add your illustration at the bottom
                            Image("Deco")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                            Spacer()
                        }
                        .navigationBarTitle("", displayMode: .inline)
                                    .navigationBarHidden(true)
                    }
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}

