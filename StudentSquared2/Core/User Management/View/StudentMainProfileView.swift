//
//  StudentMainProfileView.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 09/02/2024.
//

import SwiftUI

struct StudentMainProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView {
            ZStack() {
                //Group {
                Rectangle() //purple rectangle
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 679)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .cornerRadius(40)
                    .offset(x: 0, y: 126.50)
                
                HStack(spacing: 0) { //profile pic
                    
                    //profile pic
                }
                .padding(10)
                .frame(width: 120, height: 120)
                .offset(x: 4, y: -299)
                .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                )
                
                ZStack() {
                    //Group {
                    Rectangle() //account details rectangle
                        .foregroundColor(.clear)
                        .frame(width: 339, height: 220)
                        .background(.white)
                        .cornerRadius(26)
                        .offset(x: 0.04, y: 0)
                    
                    
                    if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
                        Text("Nur Haifa Binti Mohd Fathil") //mentor
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .frame(width: 310, alignment: .trailing)
                            .offset(y: 88)
                        //Text("FCI")
                        Text(student.course) //course
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .frame(width: 310, alignment: .trailing)
                            .offset(y: 52)
                        //Text("3")
                        Text("\(student.year)") //year
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .frame(width: 310, alignment: .trailing)
                            .offset(y: 15)
                        //Text("Aming@gmail.com")
                        Text(student.email) //email
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .frame(width: 310, alignment: .trailing)
                            .offset(y: -21)
                        //Text("Khairul Aming")
                        Text(student.fullname) //fullname
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .frame(width: 310, alignment: .trailing)
                            .offset(y: -56)
                        //Text("3")
                        Text("\(student.studentID)") //studentID
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .frame(width: 310, alignment: .trailing)
                            .offset(y: -92)
                        Text("Mentor")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                            .offset(x: -130.96, y: 88)
                        Text("Email")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                            .offset(x: -136.46, y: -21)
                        Text("Year")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                            .offset(x: -139.46, y: 15)
                    } else {
                        Text("Not Signed In")
                            .font(Font.custom("Outfit", size: 20).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73));
                    }
                    //}
                    
                    Group {
                        Text("Course")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                            .offset(x: -131.96, y: 52)
                        Text("Name")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                            .offset(x: -134.96, y: -56)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 339.91, height: 0)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
                            )
                            .offset(x: -0.50, y: 70.02)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 339.91, height: 0)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
                            )
                            .offset(x: 0.50, y: -37.92)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 339.91, height: 0)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
                            )
                            .offset(x: -0.50, y: -73.92)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 339.91, height: 0)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
                            )
                            .offset(x: -0.50, y: 34.02)
                        Rectangle()
                            .foregroundColor(.clear)
                            .frame(width: 339.91, height: 0)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
                            )
                            .offset(x: 0.50, y: -1.98)
                        Text("Student ID")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                            .offset(x: -120.96, y: -92)
                    }
                }
                .frame(width: 340.91, height: 220)
                .offset(x: 1.46, y: -76)
                
                ZStack() {
                    Text("Profile Picture")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -11, y: -1)
                    ZStack() {
                        Image("EditProfile")
                            .resizable() // Make the image resizable
                            .scaledToFit() // Scale the image to fit the frame
                    }
                    .frame(width: 20, height: 20)
                    .offset(x: 46, y: 0)
                }
                .offset(x: 0, y: -229)
                
                Rectangle() //lower rectangle
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 376)
                    .background(.white)
                    .cornerRadius(26)
                    .offset(x: -1, y: 256)
                    .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                    )
                
                Rectangle() //lower rectangle
                    .foregroundColor(.clear)
                    .frame(width: 449, height: 0)
                    .overlay(
                        Rectangle()
                            .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
                    )
                    .offset(x: -1.50, y: 366)
                
                NavigationLink(destination: StudentProfileView()) {
                    HStack {
                        Text("Notifications")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                        
                        Image("Notifications")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .offset(x:-130)
                    }
                }
                .offset(x: -50, y: 94)
                
                NavigationLink(destination: StudentProfileView()) {
                    HStack {
                        Text("Redeemed Prizes")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                        
                        Image("RedeemedPrizes")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .offset(x:-170)
                    }
                }
                .offset(x: -26, y: 142.50)
                
                NavigationLink(destination: StudentProfileView()) {
                    HStack {
                        Text("Edit Profile")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                        
                        Image("EditProfile")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .offset(x:-130)
                    }
                }
                .offset(x: -46, y: 190)
                
                NavigationLink(destination: StudentProfileView()) {
                    HStack {
                        Text("View Activity Log")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                        
                        Image("ViewActivityLog")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 28, height: 28)
                            .offset(x:-160)
                    }
                }
                .offset(x: -30.5, y: 239)
                
                NavigationLink(destination: StudentProfileView()) {
                    HStack {
                        Text("Settings")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                        
                        Image("Settings")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 35, height: 35)
                            .offset(x:-110)
                    }
                }
                .offset(x: -53, y: 288)
                
                Button {
                    print("Sign out..")
                    viewModel.signOut()
                } label : {
                    HStack {
                        Text("Log Out")
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(.black)
                        
                        Image("LogOut")
                            .resizable()
                            .scaledToFit()
                            .frame(width:30, height:30)
                            .offset(x:-106)
                    }
                }
                .offset(x: -53, y: 341)
            }
            .frame(width: 390, height: 844)
            .background(.white);
        }
    }
}

/*#Preview {
    StudentMainProfileView()
}*/

