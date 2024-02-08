//
//  GenerateQRCode.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 06/02/2024.
//

import SwiftUI
import CoreImage.CIFilterBuiltins


struct GenerateQRCode: View {
    @State private var selectedCategory: String = ""
    @State private var selectedPoints: Int = 0
    @State private var isCategorySelected: Bool = false
    @State private var points: String = ""
    @State private var startDate: Date = Date()
    @State private var endDate: Date = Date()
    @State private var startTime: Date = Date()
    @State private var endTime: Date = Date()
    @State private var remarks: String = ""
    @State private var isQRCodeSheetPresented = false
    @State private var qrCodeSheetContent: AnyView? = nil
    @EnvironmentObject var viewModel: AuthViewModel

    
    var buttonText: String {
            if isCategorySelected {
                return selectedCategory
            } else {
                return "Choose"
            }
        }
    
    var buttonPoint: Int {
            if isCategorySelected {
                return selectedPoints
            } else {
                return 0
            }
        }
    
    
    
    var combinedInformation: String {
        var information = ""
        
        // Append selectedCategory and selectedPoints
        if isCategorySelected {
            information += "Category: \(selectedCategory), "
            information += "Points: \(selectedPoints), "
        }
        
        // Append startDate and endDate
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        information += "Start Date: \(dateFormatter.string(from: startDate)), "
        information += "End Date: \(dateFormatter.string(from: endDate)), "
        
        // Append startTime and endTime
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "hh:mm a"
        information += "Start Time: \(timeFormatter.string(from: startTime)), "
        information += "End Time: \(timeFormatter.string(from: endTime)), "
        
        // Append remarks
        information += "Remarks: \(remarks)"
        
        return information
    }
        
    
    var body: some View {
        
            ZStack {
                
                
                VStack(spacing: 15) {
                    
                    Image("ScanQR") // Replace with your actual QR code image
                        .resizable()
                        .scaledToFit()
                        .frame(width: 78, height: 82)
                        .padding(.top, 20)
                        .offset(y:-75)
                    // Your text fields and labels go here, each wrapped in an HStack
                    HStack {
                       VStack {
                           Text("Category")
                                 .font(Font.custom("Outfit", size: 18).weight(.semibold))
                                 .foregroundColor(.black)
                       }
                       Spacer() // This will push the VStack to the left and the Button to the right
                       NavigationLink(destination: MeritCategory(selectedCategory: $selectedCategory, isCategorySelected: $isCategorySelected, pointsToBeAdded: $selectedPoints)) {
                           Text(buttonText) // Use the buttonText variable
                               .font(Font.custom("Outfit", size: 18).weight(.semibold))
                               .foregroundColor(.blue)
                       }
                       .padding(.horizontal) // Optional, for better spacing
                   }
                    
                    HStack {
                        VStack {
                            Text("Points")
                                .font(Font.custom("Outfit", size: 18).weight(.semibold))
                                .foregroundColor(.black)
                        }
                        Spacer() // This pushes the text to the left
                        Text("\(buttonPoint)")
                            .font(Font.custom("Outfit", size: 15))
                            .foregroundColor(.black)
                            .frame(width: 100, height: 30) // Adjust the width and height as needed
                            .multilineTextAlignment(.center) // Center align the text
                    }
                  
                    HStack {
                        VStack {
                            Text("Start Date")
                                .font(Font.custom("Outfit", size: 18).weight(.semibold))
                                .foregroundColor(.black)
                        }
                        Spacer()
                        
                        DatePicker("", selection: $startDate, displayedComponents: .date)
                            .font(Font.custom("Outfit", size: 15))
                            .foregroundColor(.black)
                    }
                  
                  HStack {
                    Text("End Date")
                      .font(Font.custom("Outfit", size: 18).weight(.semibold))
                      .foregroundColor(.black)
                    Spacer()
                      DatePicker("", selection: $endDate, displayedComponents: .date)
                          .font(Font.custom("Outfit", size: 15))
                          .foregroundColor(.black)
                    // Add your input field here for "Points"
                  }
                  
                  HStack {
                    Text("Start Time")
                      .font(Font.custom("Outfit", size: 18).weight(.semibold))
                      .foregroundColor(.black)
                    Spacer()
                      DatePicker("", selection: $startTime, displayedComponents: .hourAndMinute)
                          .font(Font.custom("Outfit", size: 15))
                          .foregroundColor(.black)
                    // Add your input field here for "Points"
                  }
                  
                  HStack {
                    Text("End Time")
                      .font(Font.custom("Outfit", size: 18).weight(.semibold))
                      .foregroundColor(.black)
                    Spacer()
                      DatePicker("", selection: $endTime, displayedComponents: .hourAndMinute)
                          .font(Font.custom("Outfit", size: 15))
                          .foregroundColor(.black)
                    // Add your input field here for "Points"
                  }
                
                // Repeat for other fields...
                
                // Remarks input field
                HStack {
                  Text("Remarks")
                    .font(Font.custom("Outfit", size: 18).weight(.semibold))
                    .foregroundColor(.black)
                  Spacer()
                    TextField("Enter Remarks", text: $remarks)
                        .font(Font.custom("Outfit", size: 15))
                        .foregroundColor(.black)
                        .multilineTextAlignment(.center) // Center align the text
                        // .padding(.trailing, 20) // This adds right padding to the TextField
                        .frame(width: 100, height: 30) // Adjust the width and height as needed
                    // Add your input field here for "Points"
                  // Add your larger input field or text area here for "Remarks"
                }
                // .environmentObject(AuthViewModel())
                Button(action: {
                    // Debugging: Print the combined information to check its value
                    // print("Combined Information: \(combinedInformation)")
                    
                    // Handle QR code generation logic here
                    // You can use the combinedInformation property to generate the QR code
                    // Add your QR code generation code here
                    // print(combinedInformation)
                    if let staff = viewModel.currentStaff, viewModel.currentUser?.userType == .staff {
                        // Now that we've confirmed the user is a staff, we can proceed with creating the QRCodeModel
                        let qrCodeData = QRCodeModel(category: selectedCategory, points: selectedPoints, startDate: startDate, endDate: endDate, startTime: startTime, endTime: endTime, remarks: remarks, staffID: staff.staffID)
                        
                        print(qrCodeData.id)
                        qrCodeSheetContent = AnyView(QRCodeView(url: qrCodeData.id))
                        qrCodeData.saveQRCodeDataToFirestore()
                        
                        
                        
                    } else {
                        print("you are NOT a staff ")
                    }

                    isQRCodeSheetPresented=true
                    // viewModel.deleteAccount()
                    
                    // qrCodeData.saveQRCodeDataToFirestore()
                    
                    

                }) {
                    Text("Generate") // Button text
                        .font(Font.custom("Outfit", size: 18).weight(.semibold))
                        .foregroundColor(.white)
                        .frame(width: 218, height: 45)
                        .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                        .cornerRadius(12)
                }
                .padding(.horizontal) // Optional, for better spacing
              }
              .padding()
              .background(
                RoundedRectangle(cornerRadius: 8)
                  .fill(Color.white)
                  .shadow(
                    color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.20),
                    radius: 40, y: 8
                  )
              )
              .frame(width: 335, height: 417)
                
                
            }
        
        .environmentObject(viewModel)
        .sheet(isPresented: $isQRCodeSheetPresented) {
            if let content = qrCodeSheetContent {
                content
            }
        }
        
            
            
            
      }
}

struct CategorySelectionView: View {
    @Binding var selectedCategory: String
    
    var body: some View {
        // Implement category selection view here and bind the selected category to selectedCategory
        Text("Category Selection")
            .font(Font.custom("Outfit", size: 24).weight(.bold))
            .padding()
    }
}
