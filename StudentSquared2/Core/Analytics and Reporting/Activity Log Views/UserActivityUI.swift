//
//  UserActivityUI.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 11/02/2024.
//

import SwiftUI

struct UserActivityUI: View {
    var body: some View {
        
        VStack(spacing: 20) {
            ZStack() {
                Rectangle() //upper purple rectangle with arch
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 122.89)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .cornerRadius(40)
                    .offset(x: 0, y: -60)
                
                Rectangle() //bottom white rectangle
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 30)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .offset(x: 0, y: -10)
                
                Text("User List") //title
                    .font(Font.custom("Raleway", size: 20))
                    .foregroundColor(.black)
                    .offset(x: -120, y: -88)
            }
            .frame(width: 390, height: 244)
            .offset(y:-230)
        }
    }
}

#Preview {
    UserActivityUI()
}
