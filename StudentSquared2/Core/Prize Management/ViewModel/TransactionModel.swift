//
//  TransactionModel.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 12/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore

class Transaction: Identifiable, Decodable, ObservableObject{
    var id: String
    var prizeQuantitiesFinal: [String:Int] = [:]
    var status: String
    var studentID: Int
    var total_amount: Int
    var date: Date
    
    init(id: String = UUID().uuidString, status: String, studentID: Int, total_amount: Int, date: Date = Date(), prizeQuantitiesFinal: [String:Int]) {
        self.id = id
        self.status = status
        self.studentID = studentID
        self.total_amount = total_amount
        self.date = date
        self.prizeQuantitiesFinal = prizeQuantitiesFinal
    }
    
    func saveOrderTodb(){
        let db = Firestore.firestore()
        
    
        let orderData: [String: Any] = [
            "redemptionID": id,
            "date": Timestamp(date: date),
            "status": status,
            "studentID": studentID,
            "total_amount": total_amount,
            "prizeQuantitiesFinal": prizeQuantitiesFinal
        ]

        // Use `document(id)` to explicitly set the document ID
        db.collection("prize_redemption").document(id).setData(orderData) { error in
            if let error = error {
                print("Error saving redemption data: \(error.localizedDescription)")
            } else {
                print("Redemption data saved successfully with matching ID: \(self.id)")
            }
        }
    }
    
    
    static func getOrdersBasedOnStatus(status: String, completion: @escaping ([Transaction]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("prize_redemption").whereField("status", isEqualTo: status).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching transaction: \(error.localizedDescription)")
                completion(nil, error)
            }else if let documents = snapshot?.documents, !documents.isEmpty {
                var orders = [Transaction]()
                    for document in documents {
                        let data = document.data()
                        guard let redemptionID = data["redemptionID"] as? String,
                              let date = data["date"] as? Timestamp,
                              let status = data["status"] as? String,
                              let studentID = data["studentID"] as? Int,
                              let total_amount = data["total_amount"] as? Int,
                              let prizeQuantitiesFinal = data["prizeQuantitiesFinal"] as? [String:Int] else {
                            print("Error decoding document \(document.documentID)")
                            continue
                        }
                        
                        let order = Transaction(
                            id: redemptionID,
                            status: status,
                            studentID: studentID,
                            total_amount: total_amount,
                            date:date.dateValue(),
                            prizeQuantitiesFinal: prizeQuantitiesFinal
                        )
                        orders.append(order)
                    }
                    completion(orders, nil)
            }else {
                // print("No documents found with displayed true.")
                completion(nil, nil)
            }
        }
    }
    
    func deductPrizeQuantities(completion: @escaping (Error?) -> Void) {
        let db = Firestore.firestore()
        let group = DispatchGroup()
        
        for (prizeID, quantityToDeduct) in prizeQuantitiesFinal {
            group.enter()
            let prizeRef = db.collection("prize").document(prizeID)
            
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let prizeDocument: DocumentSnapshot
                do {
                    try prizeDocument = transaction.getDocument(prizeRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    group.leave()
                    return nil
                }
                
                guard let currentQuantity = prizeDocument.data()?["quantity"] as? Int else {
                    let error = NSError(domain: "App", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to fetch current quantity for prize."])
                    errorPointer?.pointee = error
                    group.leave()
                    return nil
                }
                
                let newQuantity = currentQuantity - quantityToDeduct
                if newQuantity <= 0 {
                    // If new quantity is 0 or less, delete the document.
                    transaction.deleteDocument(prizeRef)
                } else {
                    // Otherwise, just update the quantity.
                    transaction.updateData(["quantity": newQuantity], forDocument: prizeRef)
                }
                group.leave()
                return nil
            }) { _, error in
                if let error = error {
                    print("Transaction failed: \(error)")
                    completion(error)
                } else {
                    print("Transaction successfully committed!")
                }
            }
        }
        
        group.notify(queue: .main) {
            completion(nil)
        }
    }

}
