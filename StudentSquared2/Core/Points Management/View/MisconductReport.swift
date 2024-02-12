//
//  MisconductReport.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 07/02/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct MisconductReport: View {
    @State private var selectedOption = "" // Default value
    @State private var selectedDate = Date() // Default to current date
    @State private var studentID = "" // Variable to hold the input text
    @State private var misconductDetails: String = "" // Variable to hold the input text
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var suggestedPoints = ""
    @State private var agreement1: Bool = false
    @State private var agreement2: Bool = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    @State var showingAlert: Bool = false

    
    let options = ["Vandalism", "Academic Misconduct", "Dress Code", "Listens to The Weeknd"] // Your options here

    var body: some View {
        VStack {
            Text("Misconduct Form")
                .font(.system(size: 20, weight: .semibold))
                .padding(.bottom, 20)

            // Create a grouped section for the input fields
            VStack(spacing: 15) {
                // Repeat this block for each input field
                Picker("Please select an option", selection: $selectedOption) {
                    ForEach(options, id: \.self) {
                        Text($0)
                    }
                }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 322,height: 35)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                
                HStack {
                    Text("Select Date")
                        .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50)) // Adjust text color as needed
                        .padding(.leading,-5) // Adjust padding to align text as needed within the rectangle
                    
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: .date
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .labelsHidden() // Hide the default label to use the custom one
                    .padding(.leading, 80) // Adjust padding to align text as needed within the rectangle

                }
                .frame(maxWidth: .infinity)
                // .padding(.horizontal) // Adjust or remove based on your layout needs
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                .frame(width: 322, height: 35, alignment: .center) // Adjust the frame as needed

                TextField("Provide Student ID", text: $studentID)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
    
                // ... Add more blocks as needed for each input field

                // Larger input field
                TextField("Provide Details of Misconduct", text: $misconductDetails)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 74)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design

                
                VStack {
                    Button(action: {
                        showImagePicker = true
                    }) {
                        if let inputImage = inputImage {
                            Image(uiImage: inputImage)
                                .resizable()
                                .scaledToFit()
                                .frame(height: 154)
                                .cornerRadius(15)
                        } else {
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.white)
                                .frame(width: 322, height: 154)
                                .overlay(
                                    Text("Tap to select image")
                                        .foregroundColor(.gray)
                                )
                        }
                    }
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                }
                .sheet(isPresented: $showImagePicker, onDismiss: loadImage) {
                    ImagePicker(selectedImage: $inputImage)
                }
                
                TextField("Sugggested Demerit Points", text: $suggestedPoints)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
                
                VStack{
                    HStack {
                        Image(systemName: agreement1 ? "checkmark.square.fill" : "square")
                            .foregroundColor(agreement1 ? .blue : .gray)
                            .onTapGesture {
                                self.agreement1.toggle()
                            }
                        Text("I hereby declare that all the information provided in this report is true and accurate to the best of my knowledge.")
                              .font(Font.custom("Raleway", size: 10).weight(.semibold))
                              .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50));
                        
                    }.frame(width: 300, height: 25)
                    
                    HStack {
                        Image(systemName: agreement2 ? "checkmark.square.fill" : "square")
                            .foregroundColor(agreement2 ? .blue : .gray)
                            .onTapGesture {
                                self.agreement2.toggle()
                            }
                        Text("I understand that any intentional misrepresentation or dishonesty in this report may result in severe consequences, including disciplinary actions or legal measures")
                              .font(Font.custom("Raleway", size: 10).weight(.semibold))
                              .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50));
                    }.frame(width: 300, height: 40)
                }
                
                
                // Submit button
                Button(action: {
                    let misconductData = MisconductReportModel(misconductType: selectedOption, date: selectedDate, studentID: Int(studentID), details: misconductDetails, demeritPoints: Int(suggestedPoints), agreement1: agreement1, agreement2: agreement2)
                    
                    misconductData.saveOrUpdateMisconductReport()
                    
                    //save data in activity log
                    if let currentUser = viewModel.currentUser {
                        let userID = currentUser.id
                        
                        let activityLog = ActivityLogModel(id: userID, activityID: UUID().uuidString, action: "Submitted Misconduct Report", date: Timestamp())
                        activityLog.saveActivity()
                    } else {
                        // Handle the case where the current user is nil or doesn't have an ID
                        print("Current user is nil or doesn't have an ID")
                    }
                    
                    showingAlert = true
                }, label: {
                    Text("Submit")
                        .foregroundColor(.white)
                      .frame(width: 186, height: 38)
                      .background(Color(red: 0.10, green: 0, blue: 0.32))
                      .cornerRadius(12);
                })
                .alert(isPresented: $showingAlert){
                    Alert(
                        title: Text("Report Submitted!"),
                        message: Text("Your report now will be evaluated by the Admin for further action.")
                    )
                }
            }
            .padding(.horizontal)
            
        }
        .frame(width: 390, height: 730)
        .background(Color(red: 0.92, green: 0.90, blue: 0.97))
        .cornerRadius(69)
    }
    
    func loadImage() {
        // handle the selected image
    }

}


