//
//  BottomNavogationBar.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 06/02/2024.
//

import SwiftUI

struct BottomNavigationBar: View {
    let logos: [String] // This will hold the names of the images for the logos

    var body: some View {
        VStack {
            // Spacer() // Pushes the bottom bar to the bottom of the screen
            HStack(spacing: 20) { // Adjust spacing as needed
                ForEach(logos, id: \.self) { logo in
                    createLogoOnBottomBar(imageName: logo)
                }
            }
            .padding(.horizontal) // Add horizontal padding
            .frame(maxWidth: .infinity, maxHeight: 80)
            .background(Color(red: 0.85, green: 0.85, blue: 0.85))
            .cornerRadius(28)
            .shadow(color: Color.black.opacity(0.25), radius: 4, y: 4)
            .edgesIgnoringSafeArea(.bottom)
        }
    }

    func createLogoOnBottomBar(imageName: String) -> some View {
        Image(imageName)
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 25, height: 25) // Adjust the size as needed
            .foregroundColor(.black)
            .padding()
    }
}
