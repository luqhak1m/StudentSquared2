//
//  MisconductModel.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 07/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class MisconductReportModel: Identifiable, Codable, ObservableObject {
    var id: String// Unique identifier for each QR code instance
    var misconductType: String
    var date: Timestamp // Using Timestamp for Firestore compatibility
    var studentID: Int?
    var details: String
    var demeritPoints: Int?
    var agreement1: Bool=false
    var agreement2: Bool=false
    var displayed = true
    var status: Bool=false
    // Optional: Image URL if storing image references in Firestore
    var imageURL: String?
    
    // Initialize the MisconductReportModel with all properties
    init(id: String = UUID().uuidString,
         misconductType: String,
         date: Date,
         studentID: Int?,
         details: String,
         demeritPoints: Int?,
         agreement1: Bool,
         agreement2: Bool) {
        self.misconductType = misconductType
        // Convert Date to Timestamp
        self.date = Timestamp(date: date)
        self.studentID = studentID
        self.details = details
        self.demeritPoints = demeritPoints
        self.agreement1 = agreement1
        self.agreement2 = agreement2
        self.id = id
        // self.imageURL = imageURL
    }
    
    // Function to save or update the misconduct report in Firestore
    func saveOrUpdateMisconductReport() {
        let db = Firestore.firestore()
        db.collection("misconduct").document(id).setData(toDictionary()) { error in
            if let error = error {
                print("Error saving Misconduct data: \(error.localizedDescription)")
            } else {
                print("Misconduct data saved successfully")
            }
        }
    }
    
    // Function to encode model into a dictionary if needed for custom operations
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [
            "misconductType": misconductType,
            "date": date,
            "details": details,
            "agreement1": agreement1,
            "agreement2": agreement2,
            "status" : status,
            "displayed" : displayed,
            "reportID" : id
        ]
        
        // Only add studentID and points if they are not nil
           if let studentID = studentID {
               dict["studentID"] = studentID
           }
           if let points = demeritPoints {
               dict["demeritPoints"] = points
           }
        
        return dict
    }
    
    // Static function to fetch all misconduct reports
    static func fetchAllMisconductReports(completion: @escaping ([MisconductReportModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("misconduct").whereField("displayed", isEqualTo: true).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching misconduct reports: \(error.localizedDescription)")
                completion(nil, error)
            }else if let documents = snapshot?.documents, !documents.isEmpty {
                var reports = [MisconductReportModel]()
                    for document in documents {
                        let data = document.data()
                        guard let misconductType = data["misconductType"] as? String,
                              let date = data["date"] as? Timestamp,
                              let details = data["details"] as? String else {
                            print("Error decoding document \(document.documentID)")
                            continue
                        }
                        let studentID = data["studentID"] as? Int
                        let demeritPoints = data["demeritPoints"] as? Int
                        let agreement1 = data["agreement1"] as? Bool ?? false
                        let agreement2 = data["agreement2"] as? Bool ?? false
                        // let accepted = data["accepted"] as? Bool ?? false
                        // let displayed = data["displayed"] as? Bool ?? true
                        // let details = data["details"] as? String
                        // let imageURL = data["imageURL"] as? String

                        let report = MisconductReportModel(
                            id: document.documentID, // Use the document ID from Firestore
                            misconductType: misconductType,
                            date: date.dateValue(),
                            studentID: studentID,
                            details: details,
                            demeritPoints: demeritPoints,
                            agreement1: agreement1,
                            agreement2: agreement2
                            // accepted: accepted,
                            // displayed: displayed
                            // imageURL: imageURL
                        )
                        reports.append(report)
                    }
                    completion(reports, nil)
            }else {
                // print("No documents found with displayed true.")
                completion(nil, nil)
            }
        }
    }
    
    static func fetchStudentName(by studentID: Int, completion: @escaping (String?) -> Void) {
            let db = Firestore.firestore()
            db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching student data: \(error.localizedDescription)")
                    completion(nil)
                } else if let document = snapshot?.documents.first{ // Assuming studentID is unique
                    do {
                        let studentData = try document.data(as: Student.self)
                        print("Fetched student name: \(studentData.fullname)")
                        completion(studentData.fullname)
                    } catch {
                        print("Error decoding student data: \(error)")
                        completion(nil)
                    }
                } else if let documents = snapshot?.documents, documents.isEmpty {
                    print("No documents found with studentID: \(studentID)")
                    completion(nil)
                }
                    else {
                        // print("something happened")
                        completion(nil)
                }
            }
        }
    
    func updateAcceptedStatus(accepted: Bool, completion: @escaping (Bool) -> Void) {

            let db = Firestore.firestore()
            db.collection("misconduct").document(id).updateData([
                "status": status
            ]) { error in
                if let error = error {
                    print("Error updating accepted status: \(error.localizedDescription)")
                    completion(false)
                } else {
                    // print("Status updated successfully")
                    completion(true)
                }
            }
        
            db.collection("misconduct").document(id).updateData([
                "displayed": false
            ]) { error in
                if let error = error {
                    print("Error updating displayed status: \(error.localizedDescription)")
                    completion(false)
                } else {
                    // print("Status updated successfully")
                    completion(true)
                }
            }
        
        
        }
    
    func deductPointsForMisconduct(completion: @escaping (Bool, Error?) -> Void) {
        print("executed...")
        guard let studentID = self.studentID, let pointsToDeduct = self.demeritPoints else {
            print("Missing student ID or demerit points.")
            completion(false, nil)
            return
        }

        let db = Firestore.firestore()
        // Adjust the query to find the student document by studentID field
        db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error finding student: \(error.localizedDescription)")
                completion(false, error)
                return
            }

            guard let document = snapshot?.documents.first else {
                print("No student found with ID: \(studentID)")
                completion(false, nil)
                return
            }

            // Proceed with deduction using a transaction
            let studentRef = document.reference
            db.runTransaction({ (transaction, errorPointer) -> Any? in
                let studentDocument: DocumentSnapshot
                do {
                    try studentDocument = transaction.getDocument(studentRef)
                } catch let fetchError as NSError {
                    errorPointer?.pointee = fetchError
                    return nil
                }

                guard let existingPoints = studentDocument.data()?["points"] as? Int else {
                    let error = NSError(domain: "App", code: 0, userInfo: [NSLocalizedDescriptionKey: "Unable to retrieve existing points."])
                    errorPointer?.pointee = error
                    return nil
                }

                // Calculate the new points total after deduction
                let newTotal = existingPoints - pointsToDeduct

                // Update the total points for the student
                transaction.updateData(["points": newTotal], forDocument: studentRef)
                return nil
            }) { (object, error) in
                if let error = error {
                    print("Transaction failed: \(error)")
                    completion(false, error)
                } else {
                    print("Transaction successfully committed!")
                    completion(true, nil)
                }
            }
        }
    }


}

