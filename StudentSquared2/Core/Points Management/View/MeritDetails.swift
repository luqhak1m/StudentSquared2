//
//  MeritDetails.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 06/02/2024.
//

import SwiftUI

struct MeritDetails: View {
    let category: String
    let points: Int
    var onConfirm: (String) -> Void  // Add this line
    
    @Environment(\.presentationMode) var presentationMode // Add this line
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Text("Merit Category")
                    .font(Font.custom("Outfit", size: 18).weight(.semibold))
                Spacer()
                Image(systemName: "bell") // Placeholder for your icon
            }
            .padding()
            .foregroundColor(.black)
            
            VStack(spacing: 20) {
                Text(category)
                    .font(Font.custom("Outfit", size: 25).weight(.semibold))
                    .foregroundColor(.black)

                Text("\(points) Points")
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(.black)

                Divider()
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))

                Text("This QR Code is for students who attends classes within the designated time and place for the whole duration of the class.")
                    .font(Font.custom("Outfit", size: 15).weight(.regular))
                    .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                    .multilineTextAlignment(.center)
                    .padding()

                Divider()
                    .background(Color(red: 0.94, green: 0.94, blue: 0.94))

                Text("Confirm?")
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(.black)

                HStack(spacing: 20) {
                    Button(action: {
                        self.onConfirm(self.category)
                        self.presentationMode.wrappedValue.dismiss() // Add this line to dismiss the view
                    }) {
                        Text("Yes")
                            .font(Font.custom("Outfit", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 102, height: 45)
                            .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .cornerRadius(12)
                    }

                    Button(action: {
                        self.presentationMode.wrappedValue.dismiss() // Add this line to dismiss the view
                    }) {
                        Text("Cancel")
                            .font(Font.custom("Outfit", size: 18).weight(.semibold))
                            .foregroundColor(.white)
                            .frame(width: 102, height: 45)
                            .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                            .cornerRadius(12)
                    }
                }
                .padding(.top, 20)
            }
            .frame(width: 335, height: 417)
            .background(.white)
            .cornerRadius(8)
            .shadow(color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.20), radius: 40, y: 8)
            .padding()

            Spacer()

            BottomNavigationBar(logos: ["BottomMore", "BottomLeaderboard", "BottomHome", "BottomQR", "BottomUser"])
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}




