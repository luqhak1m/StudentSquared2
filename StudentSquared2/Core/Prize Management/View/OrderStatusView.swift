//
//  OrderStatusView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 12/02/2024.
//

import SwiftUI


struct OrderStatusView: View {
    @State private var selectedOption: String = "Collected"
   @State private var orders: [Transaction] = []
    
    let options = ["Collected", "Processing", "Canceled"]
    
    @State private var cartItems: [PrizeModel] = []
    @State private var cart: Cart?
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        VStack {
            // Order status selection bar
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(options, id: \.self) { option in
                        Button(action: {
                            self.selectedOption = option
                        }) {
                            Text(option)
                                .font(.system(size: 18))
                                .foregroundColor(self.selectedOption == option ? .black : .gray)
                                .padding(.vertical, 8)
                                .padding(.horizontal, 12)
                                .background(self.selectedOption == option ? Color.black.opacity(0.1) : Color.clear)
                                .cornerRadius(4)
                        }
                    }
                }
                .padding(.horizontal, 30)
            }
            
            // Transactions list based on selected option
            TabView(selection: $selectedOption) {
                ForEach(options, id: \.self) { option in
                    ScrollView(.vertical, showsIndicators: true) { // Enables vertical scrolling
                        VStack {
                            ForEach(orders.filter { $0.status == option }, id: \.id) { transaction in
                                OrderCardView(
                                    status: transaction.status,
                                    orderNo: transaction.id,
                                    date: transaction.date,
                                    quantity: transaction.prizeQuantitiesFinal.values.reduce(0, +),
                                    total_amount: transaction.total_amount
                                )
                            }
                        }
                        .padding() // Add padding if needed
                    }
                    .tag(option)
                }
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            // The frame height will determine the height of the scrollable area

            
        }
        .onChange(of: selectedOption) { newValue in
                    fetchOrders(for: newValue)
        }.onAppear {
            fetchOrders(for: selectedOption)
        }
    }

    func fetchOrders(for status: String) {
            // Call your getOrdersBasedOnStatus function
            Transaction.getOrdersBasedOnStatus(status: status) { fetchedOrders, error in
                if let fetchedOrders = fetchedOrders {
                    self.orders = fetchedOrders
                } else if let error = error {
                    print("Error fetching orders: \(error.localizedDescription)")
                    // Handle the error appropriately
                }
            }
        }
    
    func fetchCartData(completion: @escaping () -> Void) {
            guard let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student else { return }
            
            Cart.fetchCart(forStudentID: student.studentID) { fetchedCart in
                guard let fetchedCart = fetchedCart else { return }
                DispatchQueue.main.async {
                    self.cart = fetchedCart
                    self.fetchPrizes(forCart: fetchedCart)
                }
            }
        
        completion() // Notify caller the operation is complete

        }
    
    private func fetchPrizes(forCart cart: Cart) {
            var fetchedItems: [PrizeModel] = []
            let group = DispatchGroup()
            for (prizeID, _) in cart.prizeQuantities { // Assuming you don't need the quantity for fetching the prize itself
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
            }
        }
    
}

struct OrderCardView: View {
    
    var status: String
    var orderNo: String
    var date: Date
    var quantity: Int
    var total_amount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack {
                HStack(alignment: .lastTextBaseline, spacing: 50) {
                    Text("Order No\(orderNo)")
                        .font(.system(size: 16, weight: .semibold))
                    Text("\(date, formatter: dateFormatter)")
                        .font(.system(size: 14))
                        .foregroundColor(.gray)
                }
                Spacer()
            }

            Divider()

            HStack {
                Text("Quantity: \(quantity)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
                Spacer()
                Text("Total Amount: \(total_amount)")
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.gray)
            }

            HStack {
                Button(action: {
                    // Detail button action
                }) {
                    Text("Detail")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(.white)
                        .frame(width: 100, height: 36)
                        .background(Color.purple)
                        .cornerRadius(4)
                }
                Spacer()
                Text(status)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(Color(red: 0.15, green: 0.68, blue: 0.38))
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(8)
        .shadow(color: Color(red: 0.54, green: 0.58, blue: 0.62, opacity: 0.20), radius: 20, y: 8)
        .frame(width: 335, height: 172)
    }
    
    private var dateFormatter: DateFormatter {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            formatter.timeStyle = .short
            return formatter
        }
}
