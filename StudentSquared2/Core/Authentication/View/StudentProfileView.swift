//
//  StudentProfileView.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 05/02/2024.
//

import SwiftUI

struct StudentProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        if let user = viewModel.currentUser {
            ZStack() {
              Group {
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 390, height: 1077)
                  .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                  .offset(x: 0, y: 116.50)
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 390, height: 735)
                  .background(.white)
                  .cornerRadius(56)
                  .offset(x: 0, y: 109.50)
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 150, height: 173)
                  .background(.white)
                  .cornerRadius(56)
                  .overlay(
                    RoundedRectangle(cornerRadius: 56)
                      .inset(by: 0.50)
                      .stroke(
                        Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50
                      )
                  )
                  .offset(x: 91, y: 40.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 150, height: 173)
                  .background(.white)
                  .cornerRadius(56)
                  .overlay(
                    RoundedRectangle(cornerRadius: 56)
                      .inset(by: 0.50)
                      .stroke(
                        Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50
                      )
                  )
                  .offset(x: -95, y: 40.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 150, height: 173)
                  .background(.white)
                  .cornerRadius(56)
                  .overlay(
                    RoundedRectangle(cornerRadius: 56)
                      .inset(by: 0.50)
                      .stroke(
                        Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50
                      )
                  )
                  .offset(x: 91, y: -154.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
                Text("Report \nMisconduct")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: 90.50, y: -115)
                Text("Redeem Prize")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: -93.50, y: 77)
                Text("Redeem Prize")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: 94.50, y: 281)
                Text("Scan QR Code")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: 94.50, y: 81)
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 390, height: 121)
                  .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                  .cornerRadius(28)
                  .offset(x: 0, y: 401.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
              };Group {
                ZStack() {
                  ZStack() {
                    ZStack() { }
                    .frame(width: 19.50, height: 19.50)
                    .offset(x: 0, y: 0)
                  }
                  .frame(width: 26, height: 26)
                  .offset(x: 73.50, y: 0)
                }
                .frame(width: 309, height: 26)
                .offset(x: -0.50, y: 377)
                ZStack() {
                  ZStack() {
                      Image("QRCodeIcon")
                          .resizable()
                          .offset(x: -1,y: -6)
                          .scaledToFit()
                          .frame(width: 80, height: 80) }
                  .frame(width: 52.50, height: 52.50)
                  .offset(x: 0, y: 0)
                }
                .frame(width: 70, height: 70)
                .offset(x: 91, y: 20)
                HStack(spacing: 0) {
                  Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 139, height: 5)
                    .background(Color(red: 0.95, green: 0.95, blue: 0.97))
                    .cornerRadius(100)
                    .rotationEffect(.degrees(-180))
                }
                .padding(EdgeInsets(top: 0, leading: 127, bottom: 0, trailing: 127))
                .frame(width: 393, height: 21)
                .offset(x: 2.50, y: 411.50)
                .opacity(0.75)
                Text("Hello,")
                  .font(Font.custom("Raleway", size: 14).weight(.light))
                  .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
                  .offset(x: -150.50, y: -300)
                  Text(user.fullname)
                  .font(Font.custom("Outfit", size: 20).weight(.semibold))
                  .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                  .offset(x: -114.50, y: -282)
                  Text(user.initials)
                      .font(Font.custom("Outfit", size: 20).weight(.semibold))
                      .fontWeight(.semibold)
                      .foregroundColor(.white)
                      .frame(width:45, height:45)
                      .background(Color(.systemGray3))
                      .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                      .offset(x: -150, y: -335.78)
                /*Rectangle() //profile picture
                  .foregroundColor(.gray)
                  .frame(width: 40, height: 40.43)
                  .cornerRadius(200)
                  .offset(x: -140, y: -335.78)*/
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 150, height: 173)
                  .background(.white)
                  .cornerRadius(56)
                  .overlay(
                    RoundedRectangle(cornerRadius: 56)
                      .inset(by: 0.50)
                      .stroke(
                        Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50
                      )
                  )
                  .offset(x: -95, y: -154.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 150, height: 173)
                  .background(.white)
                  .cornerRadius(56)
                  .overlay(
                    RoundedRectangle(cornerRadius: 56)
                      .inset(by: 0.50)
                      .stroke(
                        Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50
                      )
                  )
                  .offset(x: 95, y: 236.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
              };Group {
                Text("Settings")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: 94.50, y: 277)
                Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 150, height: 173)
                  .background(.white)
                  .cornerRadius(56)
                  .overlay(
                    RoundedRectangle(cornerRadius: 56)
                      .inset(by: 0.50)
                      .stroke(
                        Color(red: 0, green: 0, blue: 0).opacity(0.10), lineWidth: 0.50
                      )
                  )
                  .offset(x: -91, y: 236.50)
                  .shadow(
                    color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                  )
                Text("View Activity \nLog")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: -89, y: 275)
                Text("Points : 4550\nPosition : 1  ")
                  .font(Font.custom("Outfit", size: 12).weight(.semibold))
                  .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                  .offset(x: 130.50, y: -288.50)
                ZStack() { //points, position
                    /*Button {
                        print("Notifications..")
                    } label : {
                        Image("NotificationIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25, height:25)
                            .offset(x:-10,y:15)
                    }
                    Button {
                        print("Options..")
                    } label : {
                        Image("OptionsIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width:25, height:25)
                            .offset(x:20,y:15)
                    }*/
                    Button {
                        print("Sign out..")
                        viewModel.signOut()
                    } label : {
                        Image("SignOutIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width:50, height:50)
                            .offset(x:50,y:15)
                    }
                }
                .frame(width: 24, height: 24)
                .offset(x: 124, y: -339)
                ZStack() { //Hello, name
                    
                }
                .frame(width: 16, height: 16)
                .offset(x: -89, y: -281)
                ZStack() {
                    Image("ReportIcon")
                        .resizable()
                        .offset(y: -6)
                        .scaledToFit()
                        .frame(width: 90, height: 90)
                }
                .frame(width: 50, height: 50)
                .offset(x: 91, y: -183)
                ZStack() {
                  ZStack() {
                      Image("ViewProfileIcon")
                          .resizable()
                          .offset(x: 1,y: -6)
                          .scaledToFit()
                          .frame(width: 80, height: 80)
                  }
                  .frame(width: 64.17, height: 64.17)
                  .offset(x: -0, y: -0)
                }
                .frame(width: 70, height: 70)
                .offset(x: -95, y: -168)
                ZStack() {
                    Image("RedeemIcon")
                        .resizable()
                        .offset(x: -1,y: -10)
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .frame(width: 70, height: 70)
                .offset(x: -98, y: 20)
                ZStack() {
                    Image("SettingsIcon")
                        .resizable()
                        .offset(x: -2,y: -6)
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                }
                .frame(width: 70, height: 70)
                .offset(x: 97, y: 220)
              };Group {
                ZStack() {
                    Image("ActivityLogIcon")
                        .offset(x:1, y:-2)
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                }
                .frame(width: 70, height: 70)
                .offset(x: -94, y: 214)
                Text("View Profile")
                  .font(Font.custom("Outfit", size: 16).weight(.semibold))
                  .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                  .offset(x: -95.50, y: -111)
              }
            }
            .frame(width: 390, height: 844)
            .background(.white);
          }
       }
}

#Preview {
    StudentProfileView()
}
