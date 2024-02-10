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
    
    init(id: String=UUID().uuidString, imageURL: String="prize/\(UUID().uuidString).png", inventoryID: String, points_required: Int, prize_name: String, quantity: Int) {
        self.id = id
        self.imageURL = imageURL
        self.inventoryID = inventoryID
        self.points_required = points_required
        self.prize_name = prize_name
        self.quantity = quantity
    }
    
    func savePrizeDataToFirestore() {

        let db = Firestore.firestore()


        var prizeData: [String: Any] = [
            "prizeID": id,
            "imageURL": imageURL,
            "inventoryID": inventoryID,
            "prize_name": prize_name
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
        fileRef.putData(image.pngData()!){
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
                              let imageURL = data["imageURL"] as? String else {
                            print("Error decoding document \(document.documentID)")
                            continue
                        }

                        let prize = PrizeModel(
                            id: document.documentID, // Use the document ID from Firestore as the prize ID
                            imageURL: imageURL,
                            inventoryID: inventoryID,
                            points_required: points_required,
                            prize_name: prize_name,
                            quantity: quantity
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
            storageRef.getData(maxSize: 10 * 2048 * 2048) { data, error in
                guard let imageData = data, error == nil else {
                    print("Error fetching image: \(error?.localizedDescription ?? "Unknown error")")
                    completion(nil)
                    return
                }

                let image = UIImage(data: imageData)
                completion(image)
            }
        }
}
