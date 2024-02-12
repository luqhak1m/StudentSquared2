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
    var pointsID: String
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
         agreement2: Bool,
         pointsID: String = "") {
        self.misconductType = misconductType
        // Convert Date to Timestamp
        self.date = Timestamp(date: date)
        self.studentID = studentID
        self.details = details
        self.demeritPoints = demeritPoints
        self.agreement1 = agreement1
        self.agreement2 = agreement2
        self.id = id
        self.pointsID =  pointsID
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
                              let details = data["details"] as? String else{
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
                    
                    // Convert studentID to string
                    guard let studentID = self.studentID else {
                                    print("StudentID is nil")
                                    completion(false, nil)
                                    return
                                }
                    
                    // Query the student collection based on studentID
                    let db = Firestore.firestore()
                    db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (snapshot, error) in
                        if let error = error {
                            print("Error finding student with studentID \(studentID): \(error.localizedDescription)")
                            completion(false, error)
                            return
                        }
                        
                        // Check if any student document is found
                        guard let studentDocument = snapshot?.documents.first else {
                            print("No student found with studentID \(studentID)")
                            completion(false, nil)
                            return
                        }
                        
                        // Get the userID from the student document
                        guard let userID = studentDocument.data()["id"] as? String else {
                            print("Student document does not contain 'id' field")
                            completion(false, nil)
                            return
                        }
                        
                        // Query the users collection based on the userID to get the user document
                        db.collection("users").document(userID).getDocument { (userDocument, error) in
                            if let error = error {
                                print("Error finding user with ID \(userID): \(error.localizedDescription)")
                                completion(false, error)
                                return
                            }
                            
                            // Check if user document is found
                            guard let userDocument = userDocument else {
                                print("No user found with ID \(userID)")
                                completion(false, nil)
                                return
                            }
                            
                            // Create an activity log entry for the deducted points
                            let activityLog = ActivityLogModel(id: userID, activityID: UUID().uuidString, action: "\(self.demeritPoints ?? 0) points deduction", date: Timestamp())
                            
                            // Save the activity log
                            activityLog.saveActivity()
                        }
                    }
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

    func updatePointsID(newPointsID: String, completion: @escaping (Bool, Error?) -> Void) {
        // Update the local model first
        self.pointsID = newPointsID
        
        let db = Firestore.firestore()
        // Assuming the collection name is "misconduct" and `id` is the document ID
        db.collection("misconduct").document(self.id).updateData(["pointsID": newPointsID]) { error in
            if let error = error {
                print("Error updating pointsID: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("pointsID updated successfully")
                completion(true, nil)
            }
        }
    }
    
    static func fetchMisconductsForStudent(studentID: Int, completion: @escaping ([MisconductReportModel]) -> Void) {
        let db = Firestore.firestore()
        db.collection("misconduct").whereField("studentID", isEqualTo: studentID).getDocuments { snapshot, error in
            var misconducts: [MisconductReportModel] = []
            if let error = error {
                print("Error fetching misconducts: \(error.localizedDescription)")
                completion([])
                return
            }

            guard let snapshot = snapshot, !snapshot.documents.isEmpty else {
                print("No misconducts found")
                completion([])
                return
            }

            for document in snapshot.documents {
                let data = document.data()
                guard let misconductType = data["misconductType"] as? String,
                      let date = data["date"] as? Timestamp,
                      let details = data["details"] as? String,
                      let demeritPoints = data["demeritPoints"] as? Int,
                      let agreement1 = data["agreement1"] as? Bool,
                      let agreement2 = data["agreement2"] as? Bool,
                      let status = data["status"] as? Bool,
                      let displayed = data["displayed"] as? Bool,
                      let pointsID = data["pointsID"] as? String else {
                          print("Error decoding misconduct data")
                          continue
                      }

                let misconduct = MisconductReportModel(
                    id: document.documentID,
                    misconductType: misconductType,
                    date: date.dateValue(),
                    studentID: studentID,
                    details: details,
                    demeritPoints: demeritPoints,
                    agreement1: agreement1,
                    agreement2: agreement2,
                    pointsID: pointsID
                    // status: status,
                    // displayed: displayed
                )
                misconducts.append(misconduct)
            }

            completion(misconducts)
        }
    }

    static func removeMisconduct(by id: String, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("misconduct").document(id).delete() { error in
            if let error = error {
                print("Error removing misconduct report: \(error.localizedDescription)")
                completion(false, error)
            } else {
                print("Misconduct report successfully removed")
                completion(true, nil)
            }
        }
    }
    
    // Function to fetch the associated PointModel based on pointsID
    func fetchAssociatedPointModel(completion: @escaping (PointModel?, Error?) -> Void) {
        let db = Firestore.firestore()
        // Assuming your PointModel documents include a "pointID" field
        db.collection("points").whereField("pointID", isEqualTo: self.pointsID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error fetching point with ID \(self.pointsID): \(error.localizedDescription)")
                completion(nil, error)
                return
            }
            
            guard let documents = querySnapshot?.documents, !documents.isEmpty else {
                print("No point found with ID \(self.pointsID)")
                completion(nil, nil)
                return
            }
            
            // Assuming the pointID is unique and thus only one document should be returned
            let document = documents.first!
            let data = document.data()
            
            guard
                  let category = data["category"] as? String,
                  let amount = data["amount"] as? Int,
                  let reason = data["reason"] as? String else {
                      print("Error decoding point data")
                      completion(nil, nil)
                      return
                  
                  }
            let pointCategory = PointCategory(rawValue: category)
            let pointModel = PointModel(
                amount: amount,
                category: pointCategory ?? .merit,
                reason: reason
            )
            // print("Fetched student name: \(studentData.fullname)")
            completion(pointModel, nil)
        }
    }


}



