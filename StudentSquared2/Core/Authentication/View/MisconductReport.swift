//
//  MisconductReport.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 07/02/2024.
//

import SwiftUI

struct MisconductReport: View {
    @State private var selectedOption = "Option1" // Default value
    @State private var selectedDate = Date() // Default to current date
    @State private var studentID = "" // Variable to hold the input text
    @State private var misconductDetails = "" // Variable to hold the input text
    @State private var showImagePicker = false
    @State private var inputImage: UIImage?
    @State private var suggestedPoints = ""
    
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
                .frame(width: 356,height: 35)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                
                VStack {
                    DatePicker(
                        "Select Date",
                        selection: $selectedDate,
                        displayedComponents: .date
                        
                    )
                    .datePickerStyle(CompactDatePickerStyle())
                    .frame(maxWidth: .infinity)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    //.padding(.horizontal)
                }
                .frame(width: 322, height: 35, alignment: .center)

                
                TextField("Provide Student ID", text: $studentID)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
    
                // ... Add more blocks as needed for each input field

                // Larger input field
                TextField("Provide Details of Misconduct", text: $misconductDetails)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(height: 74)
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
                                .frame(height: 154)
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
                    .frame(height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
                // Submit button
                Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    Text("Submit")
                        .foregroundColor(.white)
                      .frame(width: 186, height: 38)
                      .background(Color(red: 0.10, green: 0, blue: 0.32))
                      .cornerRadius(12);
                })
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
