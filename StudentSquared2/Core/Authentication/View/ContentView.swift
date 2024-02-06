//
//  ContentView.swift
//  StudentSquared
//
//  Created by Luqman Hakim on 15/01/2024.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State private var redirectToProfile = false
    
    var body: some View {
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
        .onReceive(viewModel.$userSession) { userSession in
            // Check if the user is logged in and redirect to profile view
            if let _ = userSession {
                redirectToProfile = true
            } else {
                // If user signs out, reset redirection state
                redirectToProfile = false
            }
        }
        .fullScreenCover(isPresented: $redirectToProfile) {
            // Present appropriate profile view based on user type
            if let userType = viewModel.currentUser?.userType {
                profileViewForUserType(userType)
            } else {
                Text("User type not available")
            }
        }
        .onDisappear {
            // Perform actions when ContentView disappears (e.g., logging out)
            if !redirectToProfile {
                // Reset current user and current student/staff
                viewModel.currentUser = nil
                viewModel.currentStudent = nil
                viewModel.currentStaff = nil
            }
        }
    }
    
    func profileViewForUserType(_ userType: UserType?) -> some View {
        // Define profile views for different user types
        /*let studentProfile = NavigationView {
            StudentProfileView()
        }
        
        let staffProfile = NavigationView {
            StaffProfileView()
        }*/
        
        // Return the appropriate profile view
        switch userType {
            case .student:
                //return AnyView(studentProfile)
                return AnyView(StudentProfileView())
            case .staff:
                return AnyView(StaffProfileView())
            default:
                // Handle scenario where user type is not available
                // Return a default view or show an error message
                //viewModel.signOut() // force sign out
                return AnyView(Text("User type not available"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AuthViewModel())
    }
}
