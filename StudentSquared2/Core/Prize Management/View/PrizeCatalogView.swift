//
//  PrizeCatalogView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 11/02/2024.
//

import SwiftUI

struct PrizeCatalogView: View {
    @State private var selectedOption: String = "Popular"
    @State private var prizeList: [PrizeModel] = []
    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    @EnvironmentObject var viewModel: AuthViewModel
    
    let options: [(String, String)] = [
            ("Popular", "Popular"), // Replace icon names with actual asset names
            ("Food", "Food"),
            ("Drinks", "Drink"),
            ("Voucher", "Voucher"),
            ("Plushie", "Plushie")
        ]
    
    private func filteredPrizes(forCategory category: String) -> [PrizeModel] {
            return prizeList.filter { $0.category == category }
        }
    
    var body: some View {
        
        HStack{
            
            VStack{
                Text("Prizes")
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                    .foregroundColor(.black)
                    .multilineTextAlignment(.leading)
                if let student = viewModel.currentStudent, viewModel.currentUser?.userType == .student{
                    Text("Total Points: \(student.points)")
                        .font(Font.custom("Outfit", size: 10).weight(.semibold))
                        .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60));
                }
            }
            .padding(.leading, 40) // Add padding to the leading edge of the VStack

            Spacer() // This pushes the VStack to the left and the HStack to the right

            HStack {
                NavigationLink(destination: MainMenuView()) {
                    Image("Search Prize")
                        
                }
                NavigationLink(destination: OrderStatusView()) {
                    Image("Order")
                       
                }
                NavigationLink(destination: CartView()) {
                    Image("Cart Prize")
                        
                }
            }

            .offset(x:-60)
        }
        // Custom Tab Bar for Options
        ScrollView(.horizontal, showsIndicators: false) {
            HStack {
                ForEach(options, id: \.0) { (option, icon) in
                    VStack {
                        Image(icon) // Assuming system icons, replace with your actual icons
                            .font(.title2.weight(selectedOption == option ? .semibold : .regular))
                            .foregroundColor(selectedOption == option ? .black : .gray)
                        Text(option)
                            .font(Font.custom("Nunito Sans", size: 14))
                            .fontWeight(selectedOption == option ? .semibold : .regular)
                            .foregroundColor(selectedOption == option ? .black : .gray)
                    }
                    .padding(.horizontal, 6)
                    .onTapGesture {
                        self.selectedOption = option
                    }
                }
            }
            .padding(.horizontal, 30)
        }
        
        // TabView for Category Content
        TabView(selection: $selectedOption) {
            ForEach(options, id: \.0) { (option, _) in
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(filteredPrizes(forCategory: option), id: \.id) { prize in
                            NavigationLink(destination: CatalogDetailView(prize: prize)) { // Pass the selected prize to the detail view
                                PrizeCatalog(prize: prize)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                }
                .tag(option)
            }
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .frame(height: 300) // Adjust based on your content

        Spacer()

        .onAppear() {
            PrizeModel.fetchAllPrizes { fetchedPrizes, error in
                if let fetchedPrizes = fetchedPrizes {
                    self.prizeList = fetchedPrizes
                } else if let error = error {
                    print("Error fetching prizes: \(error.localizedDescription)")
                    // Handle the error appropriately in your app
                }
            }
        }
    }
    
    struct PrizeCatalog: View {
        var prize: PrizeModel
        @State private var image: UIImage? = nil
        
        var body: some View {
            VStack {
                VStack{
                    // The image should be loaded from the imageURL, for now, it's a placeholder
                    if let image = image {
                        Image(uiImage: image)
                            .resizable()
                            .frame(width: 80, height: 94.06)
                            .cornerRadius(6)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 0.50)
                            )
                    } else {
                        Image("whittakers")
                            .resizable()
                            .frame(width: 80, height: 94.06)
                            .cornerRadius(6)
                            .overlay(
                                Rectangle()
                                    .stroke(Color(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 0.50)
                            )
                    }
                    
    
                    
                }
                .frame(width: 165, height: 194)
                .background(Color.white) // Make sure the background is white for the shadow to stand out
                .cornerRadius(8)
                .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4) // Adjust the shadow properties as needed
                VStack(alignment: .leading, spacing: 1) {
                    Text(prize.prize_name) // Use the prize name
                        .font(Font.custom("Nunito Sans", size: 16).weight(.semibold))
                        .foregroundColor(.black)

                    
                    Text("Required Points: \(prize.points_required ?? 0)") // Use the required points
                        .font(Font.custom("Nunito Sans", size: 16).weight(.bold))
                        .foregroundColor(.black)
                }
                .padding(.horizontal,6)
                .offset(y:5)
                
            }
            
           
            .onAppear {
                prize.fetchImage { fetchedImage in
                    self.image = fetchedImage
                }
            }
        }
    }
}

#Preview{
    PrizeCatalogView()
    
}
