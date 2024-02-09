import SwiftUI

struct StaffProfileView: View {
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        NavigationView{
            ZStack {
                UserHeaderView()
                    .offset(y: -350)
                    .environmentObject(viewModel)
                // Large white rectangle at the back
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 730)
                    .background(.white)
                    .cornerRadius(56)
                    .offset(y: 100) // Adjust this value to change the vertical positioning

                if let staff = viewModel.currentUser, viewModel.currentUser?.userType == .staff{
                    
                }
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        createNavigationLinkWithImage(imageName: "Profile", label: "View Profile", destination: LecturerMainProfileView())
                        createNavigationLinkWithImage(imageName: "Log", label: "Report Misconduct", destination: MisconductReport())
                        createNavigationLinkWithImage(imageName: "Log", label: "View Misconduct Report", destination: MisconductPreview())
                        createNavigationLinkWithImage(imageName: "QR", label: "Generate QR Code", destination: GenerateQRCode())
                        createNavigationLinkWithImage(imageName: "History", label: "View Activity Log", destination: MainMenuView())
                        createNavigationLinkWithImage(imageName: "Setting", label: "Settings", destination: MainMenuView())
                    }
                    .padding()
                }
                .offset(y: 175)

                // The bottom rectangle, adjusted to be partially off-screen
                // VStack {
                    // Spacer() // Pushes the bottom bar to the bottom of the screen
                    // HStack(spacing: 20) { // Adjust spacing as needed
                        // createLogoOnBottomBar(imageName: "BottomMore") // Replace with actual image names
                        // createLogoOnBottomBar(imageName: "BottomLeaderboard")
                        // createLogoOnBottomBar(imageName: "BottomHome")
                        // createLogoOnBottomBar(imageName: "BottomQR")
                        // createLogoOnBottomBar(imageName: "BottomUser")
                    // }
                    // .padding(.horizontal) // Add horizontal padding
                    // .frame(maxWidth: .infinity, maxHeight: 121)
                    // .background(Color(red: 0.85, green: 0.85, blue: 0.85))
                    // .cornerRadius(28)
                    // .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    // .edgesIgnoringSafeArea(.bottom)
                // }
                .edgesIgnoringSafeArea(.all) // Ignore safe area to extend the background to the screen edges
            }
        
        }

    }
    
    struct UserHeaderView: View {
        @EnvironmentObject var viewModel: AuthViewModel
        
        var body: some View {
            ZStack {
                Color(red: 0.92, green: 0.90, blue: 0.97)
                    .edgesIgnoringSafeArea(.top)
                    .frame(height: 220) // You might need to adjust this height

                VStack {
                    HStack {
                        VStack(alignment: .leading){
                            Image("PFP Aisyah") // Replace with actual profile image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                                .clipShape(Circle())
                                .padding(.leading)

                            Text("Hello,")
                                .foregroundColor(.white)
                                .font(.headline)
                                .padding(.leading, 10)
                            if let user = viewModel.currentUser {
                                Text(user.fullname)
                                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                                    .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73));
                            }else{
                                Text("Not Signed In")
                                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                                    .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73));
                            }
                            //Text("Not Signed In")
                                //.font(Font.custom("Outfit", size: 20).weight(.semibold))
                                //.foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73));
                            
                        }
                        .offset(y:65)
                        .offset(x:15)

                        Spacer()
                            
                    }
                    .padding(.top, 20)

                    HStack {
                        Spacer()

                        VStack(alignment: .trailing, spacing: 4) {
                            HStack {
                                Image(systemName: "bell.fill") // Replace with your actual bell icon
                                    .foregroundColor(.white)
                                Image(systemName: "line.horizontal.3") // Replace with your actual menu icon
                                    .foregroundColor(.white)
                                Button {
                                    print("Sign out..")
                                    viewModel.signOut()
                                } label : {
                                    Image("SignOutIcon")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width:30, height:30)
                                        // .offset(x:50,y:15)
                                }
                            }
                            .offset(y:-20)
                            .offset(x:-15)

                            
                            VStack(alignment: .leading){
                                Text("Points: 4550")
                                    .font(Font.custom("Outfit", size: 12).weight(.semibold))
                                    .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73));
                                Text("Position: 1")
                                    .font(Font.custom("Outfit", size: 12).weight(.semibold))
                                    .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73));
                            }
                            .offset(x:-15)

                            
                        }
                        .padding(.trailing)
                    }
                    .padding(.bottom, 50)
                }
            }
        }
    }

    // Function to create a styled NavigationLink with an image and label
    func createNavigationLinkWithImage<Destination: View>(
        imageName: String,
        label: String,
        destination: Destination
    ) -> some View {

        NavigationLink(destination: destination) {
            VStack {
                Image(imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 70, height: 70)
                    // .clipShape(Circle())
                    .padding(.bottom, 8)
                
                Text(label)
                    .font(.caption)
                    .foregroundColor(.black)
            }
            .frame(width: 150, height: 173)
            .background(Color.white)
            .cornerRadius(56)
            .overlay(
                RoundedRectangle(cornerRadius: 56)
                    .stroke(Color.black.opacity(0.10), lineWidth: 0.50)
            )
            .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
        }
    }


    func createLogoOnBottomBar(imageName: String) -> some View {
        Image(imageName) // Using systemName for SF Symbols, replace with your actual image names if they are custom
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25) // Adjust the size as needed
            .foregroundColor(.black)
            .padding()
    }
}
