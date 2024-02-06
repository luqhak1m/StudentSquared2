import SwiftUI

struct StaffProfileView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        
        if let user = viewModel.currentUser {
            ZStack() {
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 735)
                    .background(.white)
                    .cornerRadius(56)
                    .offset(x: 0, y: 109.50)
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
                    .offset(x: -144.50, y: -300)
                
                Text(user.fullname)
                //Text(User.MOCK_USER.fullname)
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                    .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                    .offset(x: -114.50, y: -282)
                
                Text(user.fullname)
                //Text(User.MOCK_USER.initials)
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
                    .frame(width:45, height:45)
                    .background(Color(.systemGray3))
                    .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    .offset(x: -150, y: -335.78)
                
                Group{
                    Button {
                        print("Sign out..")
                        viewModel.signOut()
                    } label : {
                        Image("SignOutIcon")
                            .resizable()
                            .scaledToFit()
                            .frame(width:30, height:30)
                        //.offset(x:50,y:15)
                    }
                }
                .offset(x: 154, y: -339)
                
                Group {
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
                        .offset(x: -91, y: -154.50)
                        .shadow(
                            color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                        );
                    
                    Button(action: {
                        // Action for "View Profile" button
                        print("View Profile")
                    }) {
                        VStack {
                            ZStack() {
                                Image("ViewProfileIcon")
                                    .resizable()
                                    .offset(x: 0, y: -6)
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                            }
                            .frame(width: 70, height: 70)
                            Text("View Profile")
                                .font(Font.custom("Outfit", size: 16).weight(.semibold))
                                .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                        }
                    }
                    .offset(x: -90, y: -150)
                    
                    Group {
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
                            );
                        Button(action: {
                            // Action for "Report Misconduct" button
                            print("Report Misconduct")
                        }) {
                            VStack {
                                ZStack() {
                                    Image("ReportIcon")
                                        .resizable()
                                        .offset(y: -15)
                                        .scaledToFit()
                                        .frame(width: 90, height: 90)
                                }
                                .frame(width: 50, height: 50)
                                Text("Report \nMisconduct")
                                    .font(Font.custom("Outfit", size: 16).weight(.semibold))
                                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            }
                        }
                        .offset(x: 90.50, y: -135)
                    }
                    
                    Group{
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
                            .offset(x: 91, y: 50)
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                            );
                        Button(action: {
                            // Action for "Scan QR Code" button
                            print("Generate QR Code")
                        }) {
                            VStack {
                                ZStack() {
                                    Image("QRCodeIcon")
                                        .resizable()
                                        .offset(x: -1, y: -6)
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                .frame(width: 70, height: 70)
                                Text("Generate \nQR Code")
                                    .font(Font.custom("Outfit", size: 16).weight(.semibold))
                                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            }
                        }
                        .offset(x: 92.50, y: 57)
                    }
                    
                    Group {
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
                            .offset(x: -91, y: 57) //rectangle position
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                            );
                        Button(action: {
                            // Action for "View Activity Log" button
                            print("View Activity Log")
                        }) {
                            VStack {
                                ZStack() {
                                    Image("ActivityLogIcon")
                                        .offset(x: 1, y: -2)
                                        .scaledToFit()
                                        .frame(width: 50, height: 50)
                                }
                                .frame(width: 70, height: 70)
                                Text("View Activity \nLog")
                                    .font(Font.custom("Outfit", size: 16).weight(.semibold))
                                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            }
                        }
                        .offset(x: -94, y: 57) //button position
                    }
                    
                    Group{
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
                            .offset(x:0 , y: 250)
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                            );
                        Button(action: {
                            // Action for "Settings" button
                            print("Settings")
                        }) {
                            VStack {
                                ZStack() {
                                    Image("SettingsIcon")
                                        .resizable()
                                        .offset(x: -2, y: -6)
                                        .scaledToFit()
                                        .frame(width: 80, height: 80)
                                }
                                .frame(width: 70, height: 70)
                                Text("Settings")
                                    .font(Font.custom("Outfit", size: 16).weight(.semibold))
                                    .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            }
                        }
                        .offset(x: 0, y: 250)
                    }
                }
            }
            .frame(width: 390, height: 844)
            .background(Color(red: 0.92, green: 0.90, blue: 0.97))
        }
    }
}

struct StaffProfileView_Previews: PreviewProvider {
    static var previews: some View {
        StaffProfileView()
    }
}

