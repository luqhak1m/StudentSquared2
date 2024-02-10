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
                            .offset(x: 70.54, y: 88)
                        Text(student.course) //course
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .offset(x: 62.04, y: 52)
                        Text("\(student.year)") //year
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .offset(x: 151.54, y: 15)
                        Text(student.email) //email
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .offset(x: 49.54, y: -21)
                        Text(student.fullname) //fullname
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .offset(x: 94.54, y: -56)
                        Text("\(student.studentID)") //studentID
                            .font(Font.custom("Outfit", size: 14).weight(.semibold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .offset(x: 120.04, y: -92)
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
                    Text("Notifications")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -45, y: 94)
                    
                    Image("Notifications")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .offset(x: -180, y: 94)
                }
                
                NavigationLink(destination: StudentProfileView()) {
                    Text("Redeemed Prizes")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -24, y: 142)
                    
                    Image("RedeemedPrizes")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .offset(x: -198, y: 142.50)
                }
                
                NavigationLink(destination: StudentProfileView()) {
                    Text("Edit Profile")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -45, y: 190)
                    
                    Image("EditProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .offset(x: -175, y: 190)
                }
                
                NavigationLink(destination: StudentProfileView()) {
                    Text("Edit Profile")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -45, y: 190)
                    
                    Image("EditProfile")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .offset(x: -175, y: 190)
                }
                
                NavigationLink(destination: StudentProfileView()) {
                    Text("View Activity Log")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -30, y: 239)
                    
                    Image("ViewActivityLog")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .offset(x: -194, y: 239)
                }
                
                NavigationLink(destination: StudentProfileView()) {
                    Text("Settings")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -50, y: 288)
                    
                    Image("Settings")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 35, height: 35)
                        .offset(x: -166, y: 288)
                }
                
                Button {
                    print("Sign out..")
                    viewModel.signOut()
                } label : {
                    Text("Log Out")
                        .font(Font.custom("Outfit", size: 14).weight(.semibold))
                        .foregroundColor(.black)
                        .offset(x: -51, y: 341)
                    
                    Image("LogOut")
                        .resizable()
                        .scaledToFit()
                        .frame(width:30, height:30)
                        .offset(x: -162.5, y: 341)
                }
            }
            .frame(width: 390, height: 844)
            .background(.white);
        }
    }
}

/*#Preview {
    StudentMainProfileView()
}*/


