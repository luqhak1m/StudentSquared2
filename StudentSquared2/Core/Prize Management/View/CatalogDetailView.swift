//
//  CatalogDetailView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 11/02/2024.
//

import SwiftUI

struct CatalogDetailView: View {
    var prize: PrizeModel // Add this property
    @EnvironmentObject var viewModel: AuthViewModel
    @State var showingAlert: Bool = false
    @State private var quantity: Int = 1
    var body: some View {
        if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
            VStack(alignment: .leading) {
                Image("Deco") // Replace with your actual image
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .offset(x: 20) // Adjust the offset to make the image slightly to the right
                    .padding(.top, 30)

                Text(prize.prize_name)
                    .font(Font.custom("Outfit", size: 24).weight(.medium))
                    .foregroundColor(Color(red: 0.19, green: 0.19, blue: 0.19))
                    .padding(.top, 30)

                let points_required = prize.points_required
                Text("\(points_required ?? 0) Points")
                    .font(Font.custom("Outfit", size: 30).weight(.bold))
                    .foregroundColor(Color(red: 0.19, green: 0.19, blue: 0.19))
                    .padding(.top, 10)

                HStack {
                    Button(action: {
                        if quantity > 1 { quantity -= 1 }
                    }) {
                        Image(systemName: "minus.circle")
                    }

                    Text("\(quantity)")
                        .padding(.horizontal)

                    Button(action: {
                        quantity += 1
                    }) {
                        Image(systemName: "plus.circle")
                    }
                }
                .font(Font.custom("Outfit", size: 24))
                .foregroundColor(.black)
                .padding(.top, 10)

                Text("\(prize.description)")
                    .font(Font.custom("Nunito Sans", size: 14).weight(.light))
                    .foregroundColor(Color(red: 0.38, green: 0.38, blue: 0.38))
                    .padding(.top, 10)

                
                
                Text("Total Points: \(student.points)")
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                    .foregroundColor(.black)
                    .padding(.top, 10)

                HStack {
                    Button("Add to Cart") {
                        let redemption = PrizeRedemptionModel(
                            date: Date(),
                            prizeID: prize.id,
                            prize_quantity: quantity,
                            studentID: student.studentID)
                        
                        // USED HERE
                        redemption.addToCart()
                        showingAlert = true
                    }
                    .padding()
                    .background(Color(red: 0.10, green: 0, blue: 0.32))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .alert(isPresented: $showingAlert){
                        Alert(
                            title: Text("Prize Added to Cart!"),
                            message: Text("Prize has been added to the cart.")
                        )
                    }

                    Button("Redeem Now") {
                        // Handle redeem action
                    }
                    .padding()
                    .background(Color(red: 0.10, green: 0, blue: 0.32))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .alert(isPresented: $showingAlert){
                        Alert(
                            title: Text("Please use the add to cart feature!"),
                            message: Text("This feature has not been implemented yet. Sorry for the inconvenience :)")
                        )
                    }
                }
                .padding(.top, 20)
            }
            .padding()
        }
    }
}

//#Preview {
//    CatalogDetailView()
//}
