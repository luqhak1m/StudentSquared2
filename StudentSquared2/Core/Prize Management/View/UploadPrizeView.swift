//
//  UploadPrizeView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 10/02/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

struct UploadPrizeView: View {
    
    @State private var prizeList: [PrizeModel] = []

        var body: some View {
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(prizeList, id: \.id) { prize in
                        PrizeCard(prize: prize)
                    }
                }
                .padding(.top, 20)
            }.onAppear() {
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
}

struct EditPrizeView: View {
    
    @ObservedObject var viewModel: EditPrizeViewModel
    @EnvironmentObject var viewModelAuth: AuthViewModel


    var body: some View {
        
        NavigationView {
            
            Form {
                Section(header: Text("Prize Details")) {
                    TextField("Prize Name", text: $viewModel.prizeName)
                    TextField("Category", text: $viewModel.category)
                    TextField("Description", text: $viewModel.description)
                    TextField("Points Required", value: $viewModel.pointsRequired, formatter: NumberFormatter())
                    TextField("Quantity", value: $viewModel.quantity, formatter: NumberFormatter())
                }
            }
            .navigationTitle("Edit Prize")
            .toolbar {
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if let currentUser = viewModelAuth.currentUser{
                        let userID = currentUser.id
                        Button("Save") {
                            viewModel.saveChanges()
                            let activityLog = ActivityLogModel(id: userID, action: "Edited prize", date: Timestamp())
                            activityLog.saveActivity()
                        }
                    }
                    
                }
            }
        }
    }
}


struct PrizeCard: View {
    var prize: PrizeModel
        @State private var image: UIImage? = nil
        @State private var showingEditSheet = false
        @StateObject private var editViewModel = EditPrizeViewModel()
    @EnvironmentObject var viewModel: AuthViewModel



    var body: some View {
        ZStack {
            VStack {
                Text(prize.id) // Use the prize ID
                    .font(Font.custom("Outfit", size: 16).weight(.semibold))
                    .foregroundColor(Color(red: 0.14, green: 0.14, blue: 0.14))
                    .padding(.top, 16)
                    .offset(y:-10)

                
                Divider()

                HStack(alignment: .top, spacing: 12) {
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
                        Rectangle()
                            .fill(Color.gray.opacity(0.3))
                            .frame(width: 80, height: 94.06)
                            .cornerRadius(6)
                            .overlay(
                                Text("Loading...")
                                    .foregroundColor(.white)
                            )
                    }

                    VStack(alignment: .leading, spacing: 8) {
                        Text(prize.prize_name) // Use the prize name
                            .font(Font.custom("Nunito Sans", size: 16).weight(.bold))
                            .foregroundColor(Color(red: 0.46, green: 0.36, blue: 0.73))

                        Text("Quantity: \(prize.quantity ?? 0)") // Use the quantity
                            .font(Font.custom("Nunito Sans", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))

                        Text("Required Points: \(prize.points_required ?? 0)") // Use the required points
                            .font(Font.custom("Nunito Sans", size: 16).weight(.semibold))
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                    }
                    .padding(.horizontal,6)
                    .offset(y:22)
                    
                    VStack{
                        Button("Edit") {
                            editViewModel.loadPrizeData(prize: prize)
                            showingEditSheet = true
                        }
                        .sheet(isPresented: $showingEditSheet) {
                            EditPrizeView(viewModel: editViewModel)
                        }
                        .onAppear {
                            prize.fetchImage { fetchedImage in
                                self.image = fetchedImage
                            }
                        }
                        
                        if let currentUser = viewModel.currentUser {
                            let userID = currentUser.id
                            
                            Button("Delete") {
                                prize.deletePrize(){_,_ in
                                    let activityLog = ActivityLogModel(id: userID, action: "Deleted prize", date: Timestamp())
                                    activityLog.saveActivity()
                                }
                            }
                            
                        }
                    }
                }
                .padding(.horizontal,20)
                .padding(.vertical, 5)

            }
            
            
        }
        .frame(width: 335, height: 184)
        .background(Color.white) // Make sure the background is white for the shadow to stand out
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.2), radius: 6, x: 0, y: 4) // Adjust the shadow properties as needed
        .onAppear {
            prize.fetchImage { fetchedImage in
                self.image = fetchedImage
            }
        }
    }
    
    
}



#Preview {
    UploadPrizeView()
}

