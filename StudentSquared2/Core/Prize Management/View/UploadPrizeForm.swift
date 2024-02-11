//
//  UploadPrizeForm.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 10/02/2024.
//

import SwiftUI

struct UploadPrizeForm: View {
    @State private var itemName = ""
        @State private var quantity = ""
        @State private var requiredPoints = ""
        @State private var description = ""
        @State private var showImagePicker: Bool = false
        @State private var inputImage: UIImage?
        @State private var selectedCategory = "Food" // Default category

        let categories = ["Food", "Drinks", "Voucher", "Plushie"]
    
    var body: some View {
        VStack {
            VStack(spacing: 10) {
                
                Picker("Select Category", selection: $selectedCategory) {
                   ForEach(categories, id: \.self) {
                       Text($0)
                   }
               }
                .pickerStyle(MenuPickerStyle())
                .frame(width: 322,height: 35)
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                
                TextField("Item Name", text: $itemName)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
                
                
                TextField("Quantity", text: $quantity)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
                
                TextField("Required Points", text: $requiredPoints)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 35)
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
                    .padding(.horizontal) // Add padding outside to conform to the UI design
                
                TextField("Description", text: $description)
                    .padding(.horizontal) // Add padding inside the text field for the text
                    .frame(width: 322, height: 100)
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
            }
            Button(action: {
                // Handle the submit action here
                
                guard let inputImage = inputImage,
                          let requiredPoints = Int(requiredPoints),
                          let quantity = Int(quantity) else {
                        print("Invalid input")
                        return
                    }
                
                
                
                
                let prize = PrizeModel(
                        inventoryID: "SomeInventoryID", // Replace with actual inventory ID
                        points_required: requiredPoints,
                        prize_name: itemName,
                        quantity: quantity,
                        category: selectedCategory,
                        description: description
                    )
                
                prize.savePrizeDataToFirestore()
                prize.saveImage(image: inputImage)
            }) {
                Text("Submit")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .frame(width: 186, height: 38)
                    .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                    .foregroundColor(.white)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.top, 5)
        }
    }
    
    func loadImage() {
            // Handle the loaded image if needed
        }
}

#Preview {
    UploadPrizeForm()
}

