//
//  CartView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 11/02/2024.
//

import SwiftUI

struct CartView: View {
    @State private var cartItems: [PrizeModel] = []
    @State private var cart: Cart?
    @EnvironmentObject var viewModel: AuthViewModel

    @State private var totalPoints: Int = 0   
    @State private var currentPoints: Int = 0
    @State private var errorMessage: String?
        
    var body: some View {
        List(cartItems, id: \.id) { item in
            // Assuming cart is already fetched and contains the item's quantity
            if let cart = self.cart {
                CartItemView(cart: cart, prize_name: item.prize_name, prizeID: item.id, prize_points: item.points_required ?? 0, quantity: Binding(get: {
                    cart.prizeQuantities[item.id] ?? 0
                }, set: { newValue in
                    cart.updateQuantity(forPrizeID: item.id, to: newValue){
                        fetchCartData()
                        for (prizeID, quantity) in cart.prizeQuantities {
                            if quantity == 0 {
                                cart.prizeQuantities.removeValue(forKey: prizeID)
                            }
                        }
                        // Optionally call addCartToDb to update the database with the cleaned-up dictionary
                        cart.addCartToDb {
                            print("Updated cart in database after removing prizes with zero quantity.")
                        }
                    }
                    // Optionally, add logic to update the cart in your data store or backend
                }))
            }
        }
    
    
    
        Text("Points Balance: \(currentPoints)")
              .font(Font.custom("Nunito Sans", size: 20).weight(.semibold))
              .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.18));
        Text("Total: \(totalPoints)")
              .font(Font.custom("Nunito Sans", size: 20).weight(.semibold))
              .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.18));
    
        if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
            NavigationLink(destination: CheckOutView(totalPoints: totalPoints, currentPoints: currentPoints, studentID: student.studentID, prizeQuantities: self.cart?.prizeQuantities ?? ["":0])) {
                        ZStack {
                            Rectangle()
                                .frame(width: 319, height: 55)
                                .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))
                                .cornerRadius(12)
                            Text("Check Out")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                        }
                    }.onAppear {
                        fetchCartData()
                }
            }
        }
    
    func fetchCartData() {
        guard let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student else { return }

        Cart.fetchCart(forStudentID: student.studentID) { fetchedCart in
            DispatchQueue.main.async {
                self.cart = fetchedCart
                if let fetchedCart = fetchedCart {
                    self.fetchPrizes(forCart: fetchedCart) {
                        // Now that we have fetched the prizes, calculate the total points.
                        self.calculateTotalPointsIfNeeded()
                    }
                }
            }
        }
        
        if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
            currentPoints = student.points
        }
        
        
        
    }
    
    private func fetchPrizes(forCart cart: Cart, completion: @escaping () -> Void) {
        var fetchedItems: [PrizeModel] = []
        let group = DispatchGroup()
        for (prizeID, _) in cart.prizeQuantities {
            group.enter()
            PrizeModel.fetchPrize(byID: prizeID) { (prize, error) in
                DispatchQueue.main.async {
                    if let prize = prize {
                        fetchedItems.append(prize)
                    } else if let error = error {
                        print("Error fetching prize: \(error.localizedDescription)")
                    }
                    group.leave()
                }
            }
        }

        group.notify(queue: .main) {
            self.cartItems = fetchedItems
            completion()
        }
    }

    
    func calculateTotalPoints(forCart cart: Cart, completion: @escaping (Int?, Error?) -> Void) {

        let group = DispatchGroup()
        var totalPoints = 0
        var fetchError: Error?

        for (prizeID, quantity) in cart.prizeQuantities {
            group.enter()
            PrizeModel.fetchPrize(byID: prizeID) { prize, error in
                defer { group.leave() }
                if let points = prize?.points_required{
                    print("before: \(totalPoints) += \(points) * \(quantity)")
                    totalPoints += points * quantity
                    print("aftah: \(totalPoints) += \(points) * \(quantity)")


                } else if let error = error {
                    fetchError = error
                    // Optionally break early if an error is encountered
                    // But need a way to cancel remaining group.enter() calls or handle it accordingly
                }
            }
        }

        group.notify(queue: .main) {
            if let error = fetchError {
                completion(nil, error)
            } else {
                completion(totalPoints, nil)
            }
        }
    }
    
    private func calculateTotalPointsIfNeeded() {
        if let cart = self.cart {
            calculateTotalPoints(forCart: cart) { points, error in
                if let points = points {
                    self.totalPoints = points
                } else if let error = error {
                    self.errorMessage = error.localizedDescription
                }
            }
        }
    }

}

struct CartItemView: View {
    var cart: Cart
    var prize_name: String
    var prizeID: String
    var prize_points: Int
    @Binding var quantity: Int // Changed from @State to @Binding
    // @State var quantity: Int
    
    var body: some View {
            HStack {
                // Left Image
                Image("whittakers") // Replace with your actual image name
                    .resizable()
                    .frame(width: 100, height: 100) // Adjust the size as needed
                    .cornerRadius(10)

                // Middle Text and Quantity Selector
                VStack(alignment: .leading) {
                    Text(prize_name)
                        .font(.headline)

                    Text("\(prize_points) Points")
                        .font(.subheadline)

                    
                    
                    HStack {
                        Button(action: {
                            self.quantity += 1
                            print(quantity)
                        }) {
                            Image(systemName: "plus")
                                .frame(width: 20, height: 20) // Adjust the size as needed
                        }

                        Text("\(String(format: "%02d", self.quantity))")
                            .frame(minWidth: 20, alignment: .center) // Ensure the text field is wide enough

                        Button(action: {
                            if self.quantity > 0 { self.quantity -= 1 }
                        }) {
                            Image(systemName: "minus")
                                .frame(width: 20, height: 20) // Adjust the size as needed
                        }
                    }
                }

                Spacer() // This will push the leading and trailing views to the edges

                // Right Close Button
                Button(action: {
                    // Implement removal action here
                }) {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20) // Adjust the size as needed
                        .foregroundColor(.gray)
                }
            }
            .padding() // Add padding around the HStack contents
            .background(Color.white) // Set the background color of the HStack
            .cornerRadius(10) // Round the corners of the HStack
        }
}

struct CheckOutView: View{
    var totalPoints: Int
    var currentPoints: Int
    var studentID: Int
    var prizeQuantities: [String:Int]
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showingInsufficientBalanceAlert = false


    
    var body: some View{
        if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
            Text("Points Balance: \(student.points)")
                .font(Font.custom("Nunito Sans", size: 20).weight(.semibold))
                .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.18));
            
            
            Text("Total: \(totalPoints)")
                .font(Font.custom("Nunito Sans", size: 20).weight(.semibold))
                .foregroundColor(Color(red: 0.17, green: 0.17, blue: 0.18));
            
            Button(action: {
                // Implement removal action here
                
                // calculate total
                if student.points >= totalPoints{
                    // remove item from catalog / deduct quantity
                    
                    let transaction = Transaction(
                        status: "Processing",
                        studentID: studentID,
                        total_amount: totalPoints,
                        prizeQuantitiesFinal: prizeQuantities)
                    
                    transaction.saveOrderTodb()
                    transaction.deductPrizeQuantities{ error in
                    
                        if error != nil{
                            print("error mat")

                        }else{
                            print("success mat")
                        }
                    }
                    
                    // deduct points
                    
                    PointModel.deductPoints(studentID: studentID, pointsToDeduct: totalPoints){ success, error in
                        if success{
                            print("success")
                        }else if error != nil{
                            print("error")
                        }
                    }
                    
                    // clear cart
                    
                    Cart.fetchCart(forStudentID: studentID){ cart in
                        let cart = cart
                        cart?.removeCartFromDb(){ error in
                            if error != nil{
                                print("error")
                            }
                            
                        }
                    }
                }else {
                    // Show alert if balance is insufficient
                    self.showingInsufficientBalanceAlert = true
                }
            }) {
                Text("Submit") // Button text
                    .font(Font.custom("Outfit", size: 18).weight(.semibold))
                    .foregroundColor(.white)
                    .frame(width: 218, height: 45)
                    .background(student.points >= totalPoints ? Color(red: 0.46, green: 0.36, blue: 0.73) : Color(red: 0.60, green: 0.60, blue: 0.60))
                    .cornerRadius(12)
            }.alert(isPresented: $showingInsufficientBalanceAlert) {
                Alert(title: Text("Insufficient Balance"), message: Text("You do not have enough points for this redemption."), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    
}

//#Preview(){
//    CartItemView(prize_name: "Name", prizeID: "id", quantity: 0)
//
//}
