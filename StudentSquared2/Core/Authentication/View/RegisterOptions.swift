//
//  RegisterOptions.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 17/01/2024.
//

import Foundation
import SwiftUI

struct RegisterOptions: View{
    
    var body: some View{
            ZStack {
                
                Color(.white)
                    .ignoresSafeArea()
                
                VStack {
                    
                    Image("Logo")
                        .offset(y: -20)
                    
                    NavigationLink(destination: AdminRegisterView()) {
                        Text("Register as Admin")
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
                    
                    NavigationLink(destination: StaffRegisterView()) {
                        Text("Register as Staff")
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
                    
                    NavigationLink(destination: LecturerRegisterView()) {
                        Text("Register as Lecturer")
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
                    
                    NavigationLink(destination: StudentRegisterView()) {
                        Text("Register as Student")
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
                }
            }
    }
    
}

struct RegisterOptions_Previews: PreviewProvider {
    static var previews: some View {
        RegisterOptions()
    }
}
