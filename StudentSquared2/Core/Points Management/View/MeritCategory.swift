//
//  MeritCategory.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 06/02/2024.
//

import SwiftUI

struct MeritCategory: View {
    @Binding var selectedCategory: String
    @Binding var isCategorySelected: Bool
    @Binding var pointsToBeAdded: Int
    
    let categoryPoints: [String: Int] = [
        "Attendance": 2,
        "Charity Work": 10,
        "Organized Event": 30,
        "Joined Event": 10,
        "Perfect GPA": 100,
        "Perfect Attendance": 50,
        "Uni-Level Competition": 50,
        "National-Level Competition": 300
    ]
    
    
    var body: some View {
            VStack {
                HStack {
                    Spacer()
                    Text("Merit Category")
                        .font(Font.custom("Outfit", size: 18).weight(.semibold))
                    Spacer()
                }
                .padding()
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(Array(categoryPoints.keys), id: \.self) { category in
                            let points = categoryPoints[category] ?? 0 // Get points for the category or provide a default value
                            NavigationLink(destination: MeritDetails(category: category, points: points, onConfirm: { selectedCategory in
                                self.selectedCategory = selectedCategory
                                self.pointsToBeAdded=points
                                self.isCategorySelected = true
                            })) {
                                VStack {
                                    Text(category)
                                        .font(Font.custom("Outfit", size: 20).weight(.semibold))
                                    Text("\(points) Points")
                                        .font(Font.custom("Outfit", size: 15).weight(.semibold))
                                }
                                .frame(width: 166, height: 141)
                                .background(Color.white)
                                .cornerRadius(8)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 8)
                                        .stroke(Color.black, lineWidth: 0.50)
                                )
                                .shadow(color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.20), radius: 40, y: 8)
                            }
                        }
                        
                    }
                    .padding()
                }
                
                BottomNavigationBar(logos: ["BottomMore", "BottomLeaderboard", "BottomHome", "BottomQR", "BottomUser"])
            }
            .edgesIgnoringSafeArea(.bottom)
        
    }
}


// #Preview {
//    MeritCategory(selectedCategory: .constant("test"), isCategorySelected: .constant(true))
//}


