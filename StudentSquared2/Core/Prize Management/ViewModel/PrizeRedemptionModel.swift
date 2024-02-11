//
//  PrizeRedemptionModel.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 11/02/2024.
// This thing is like a cart basically if my judgement is correct

import Foundation
import Firebase
import FirebaseFirestore

class PrizeRedemptionModel: Identifiable, Codable, ObservableObject{
    var date: Date
    var id: String
    var prizeID: String
    var prize_quantity: Int
    var studentID: Int

    init(date: Date, id: String=UUID().uuidString, prizeID: String, prize_quantity: Int, studentID: Int) {
        self.date = date
        self.id = prizeID
        self.prizeID = prizeID
        self.prize_quantity = prize_quantity
        self.studentID = studentID
    }
    
    func saveRedemptionDataToFirestore(completion: @escaping (Bool, String?) -> Void) {
        let db = Firestore.firestore()

        let prizeData: [String: Any] = [
            "redemptionID": id,
            "date": Timestamp(date: date),
            "prizeID": prizeID,
            "prize_quantity": prize_quantity,
            "studentID": studentID
        ]

        // Use `document(id)` to explicitly set the document ID
        db.collection("prize_redemption").document(id).setData(prizeData) { error in
            if let error = error {
                print("Error saving redemption data: \(error.localizedDescription)")
                completion(false, nil) // Indicate failure and no redemptionID to return
            } else {
                print("Redemption data saved successfully with matching ID: \(self.id)")
                completion(true, self.id) // Indicate success and return the redemptionID
            }
        }
    }

    
    func addToCart() {
        Cart.fetchCart(forStudentID: self.studentID) { existingCart in
            var cartToUpdate: Cart
            if let existingCart = existingCart {
                cartToUpdate = existingCart
            } else {
                cartToUpdate = Cart(id: String(self.studentID), prizeQuantities: [" " : 0], studentID: self.studentID)
            }

            let existingQuantity = cartToUpdate.prizeQuantities[self.prizeID] ?? 0
            cartToUpdate.prizeQuantities[self.prizeID] = existingQuantity + self.prize_quantity

            cartToUpdate.addCartToDb{
                
            }
        }
    }
}

class Cart: Identifiable, Codable, ObservableObject {
    var id: String
        @Published var prizeQuantities: [String: Int] // Adjusted to store prizeID: quantity pairs
        var studentID: Int

        enum CodingKeys: CodingKey {
            case id, prizeQuantities, studentID
        }

        required init(from decoder: Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            id = try container.decode(String.self, forKey: .id)
            // Since @Published property can't be directly decoded, decode the value and then assign
            let prizeQuantitiesValue = try container.decode([String: Int].self, forKey: .prizeQuantities)
            _prizeQuantities = Published(initialValue: prizeQuantitiesValue)
            studentID = try container.decode(Int.self, forKey: .studentID)
        }

        func encode(to encoder: Encoder) throws {
            var container = encoder.container(keyedBy: CodingKeys.self)
            try container.encode(id, forKey: .id)
            try container.encode(prizeQuantities, forKey: .prizeQuantities) // Directly encode the value of @Published
            try container.encode(studentID, forKey: .studentID)
        }

        init(id: String, prizeQuantities: [String: Int], studentID: Int) {
            self.id = id
            self._prizeQuantities = Published(initialValue: prizeQuantities)
            self.studentID = studentID
        }
    
    func addCartToDb(completion: @escaping () -> Void) {
        let db = Firestore.firestore()

        // Construct cart data, but consider using the studentID as the document ID directly
        let cartData: [String: Any] = [
            "cartID": id, // This is now redundant if id == studentID
            "prizeQuantities": prizeQuantities,
            "studentID": studentID
        ]

        // Use `document(id)` with the studentID to ensure uniqueness
        db.collection("cart").document(String(studentID)).setData(cartData) { error in
            if let error = error {
                print("Error saving cart data: \(error.localizedDescription)")
            } else {
                print("Cart data saved successfully for studentID \(self.studentID)")
            }
        }
        completion()
    }
    
    static func fetchCart(forStudentID studentID: Int, completion: @escaping (Cart?) -> Void) {
        let db = Firestore.firestore()
        let docRef = db.collection("cart").document(String(studentID))
        
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let id = document.documentID
                let prizeQuantities = data?["prizeQuantities"] as? [String : Int] ?? [:]
                let studentID = data?["studentID"] as? Int ?? 0 // Assuming studentID is stored as an Int, adjust if necessary
                
                let cart = Cart(id: id, prizeQuantities: prizeQuantities, studentID: studentID)
                completion(cart)
                print("found cart with id \(cart.studentID), \(cart.prizeQuantities.count) prizes")
            } else {
                print("Document does not exist or error fetching document: \(error?.localizedDescription ?? "Unknown error")")
                completion(nil)
            }
        }
    }
    
    
    
    func updateQuantity(forPrizeID prizeID: String, to newQuantity: Int, completion: @escaping () -> Void) {
        DispatchQueue.main.async {
            self.prizeQuantities[prizeID] = newQuantity
            self.addCartToDb() { // Assuming addCartToDb is modified to accept a completion handler
                // Call the completion handler after the database update is finished
                completion()
            }
        }
    }

    func removeCartFromDb(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let cartRef = db.collection("cart").document(String(studentID))

        cartRef.delete() { error in
            if let error = error {
                print("Error removing cart: \(error.localizedDescription)")
                completion(error)
            } else {
                print("Cart successfully removed")
                completion(nil)
            }
        }
    }
    

}

