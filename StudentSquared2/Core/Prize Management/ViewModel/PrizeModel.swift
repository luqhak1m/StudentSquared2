//
//  PrizeModel.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 10/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift

class PrizeModel: Identifiable, Codable, ObservableObject{
    var id: String
    var imageURL: String
    var inventoryID: String
    var points_required: Int?
    var prize_name: String
    var quantity: Int?
    var category: String
    var description: String
    
    init(id: String=UUID().uuidString, imageURL: String="prize/\(UUID().uuidString).png", inventoryID: String, points_required: Int, prize_name: String, quantity: Int, category: String, description: String) {
        self.id = id
        self.imageURL = imageURL
        self.inventoryID = inventoryID
        self.points_required = points_required
        self.prize_name = prize_name
        self.quantity = quantity
        self.category = category
        self.description = description
    }
    
    func savePrizeDataToFirestore() {

        let db = Firestore.firestore()


        var prizeData: [String: Any] = [
            "prizeID": id,
            "imageURL": imageURL,
            "inventoryID": inventoryID,
            "prize_name": prize_name,
            "category": category,
            "description": description
        ]
            
            if let points_required = points_required {
                prizeData["points_required"] = points_required
            }
            if let quantity = quantity {
                prizeData["quantity"] = quantity
            }

        // Use `document(id)` to explicitly set the document ID
        db.collection("prize").document(id).setData(prizeData) { error in
            if let error = error {
                print("Error saving QR code data: \(error.localizedDescription)")
            } else {
                print("Prize data saved successfully with matching ID")
            }
        }
        
    }
    
    func saveImage(image: UIImage){
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let fileRef = storageRef.child(imageURL)
        fileRef.putData(image.jpegData(compressionQuality: 0.5)!){
            metadata, error in
            
            if error == nil && metadata != nil{
                
            }
        }
    }
    
    // Static function to fetch all prizes
        static func fetchAllPrizes(completion: @escaping ([PrizeModel]?, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection("prize").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching prizes: \(error.localizedDescription)")
                    completion(nil, error)
                } else if let documents = snapshot?.documents, !documents.isEmpty {
                    var prizes = [PrizeModel]()
                    for document in documents {
                        let data = document.data()
                        guard let inventoryID = data["inventoryID"] as? String,
                              let prize_name = data["prize_name"] as? String,
                              let points_required = data["points_required"] as? Int,
                              let quantity = data["quantity"] as? Int,
                              let imageURL = data["imageURL"] as? String,
                              let category = data["category"] as? String,
                              let description = data["description"] as? String else {
                            print("Error decoding document \(document.documentID)")
                            continue
                        }

                        let prize = PrizeModel(
                            id: document.documentID, // Use the document ID from Firestore as the prize ID
                            imageURL: imageURL,
                            inventoryID: inventoryID,
                            points_required: points_required,
                            prize_name: prize_name,
                            quantity: quantity,
                            category: category,
                            description: description
                        )
                        prizes.append(prize)
                    }
                    completion(prizes, nil)
                } else {
                    completion(nil, nil)
                }
            }
        }
    
    func fetchImage(completion: @escaping (UIImage?) -> Void) {
            let storageRef = Storage.storage().reference(withPath: imageURL)

            // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
            storageRef.getData(maxSize: 1 * 2048 * 2048) { data, error in
                guard let imageData = data, error == nil else {
                    print("Error fetching image: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                let image = UIImage(data: imageData)
                completion(image)
            }
        }
    
    static func fetchPrize(byID prizeID: String, completion: @escaping (PrizeModel?, Error?) -> Void) {
        let db = Firestore.firestore()

        db.collection("prize").document(prizeID).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error fetching prizes: \(error.localizedDescription)")
                completion(nil, error)
            } else if let documentSnapshot = documentSnapshot, documentSnapshot.exists {
                guard let data = documentSnapshot.data() else {
                    print("Document data was empty")
                    completion(nil, nil)
                    return
                }
                    guard let inventoryID = data["inventoryID"] as? String,
                          let prize_name = data["prize_name"] as? String,
                          let points_required = data["points_required"] as? Int,
                          let quantity = data["quantity"] as? Int,
                          let imageURL = data["imageURL"] as? String,
                          let category = data["category"] as? String,
                          let description = data["description"] as? String else {
                        print("Error decoding document \(documentSnapshot.documentID)")
                        return
                    }

                    let prize = PrizeModel(
                        id: documentSnapshot.documentID, // Use the document ID from Firestore as the prize ID
                        imageURL: imageURL,
                        inventoryID: inventoryID,
                        points_required: points_required,
                        prize_name: prize_name,
                        quantity: quantity,
                        category: category,
                        description: description
                    )
                    completion(prize, nil)
                }
                
             else {
                print("No prize found")
                completion(nil, nil)
            }
        }
    }
    
    func deletePrize(completion: @escaping (Bool, Error?) -> Void) {
       let db = Firestore.firestore()
       db.collection("prize").document(self.id).delete() { error in
           if let error = error {
               print("Error deleting prize: \(error.localizedDescription)")
               completion(false, error)
           } else {
               print("Prize successfully deleted")
               completion(true, nil)
           }
       }
   }
    
    

}

class EditPrizeViewModel: ObservableObject {
    @Published var pointsRequired: Int?
    @Published var prizeName: String = ""
    @Published var quantity: Int?
    @Published var category: String = ""
    @Published var description: String = ""
    var prizeID: String? // Keep track of the prize being edited

    // Load existing prize data
    func loadPrizeData(prize: PrizeModel) {
        self.prizeID = prize.id
        self.pointsRequired = prize.points_required
        self.prizeName = prize.prize_name
        self.quantity = prize.quantity
        self.category = prize.category
        self.description = prize.description
    }

    // Function to save changes
    func saveChanges() {
        guard let prizeID = prizeID else { return }
        let db = Firestore.firestore()
        let prizeData: [String: Any] = [
            "points_required": pointsRequired as Any,
            "prize_name": prizeName,
            "quantity": quantity as Any,
            "category": category,
            "description": description
        ]
        db.collection("prize").document(prizeID).updateData(prizeData) { error in
            if let error = error {
                print("Error updating prize data: \(error.localizedDescription)")
            } else {
                print("Prize data updated successfully")
            }
        }
    }
}


