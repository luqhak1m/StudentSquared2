//
//  PointsModel.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 08/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum PointCategory: String, Codable {
    case merit = "Merit"
    case demerit = "Demerit"
}


class PointModel: Identifiable, Codable, ObservableObject {
    var id: String
    var amount: Int
    var category: PointCategory
    var reason: String
    
    init(amount: Int, category: PointCategory, id: String = UUID().uuidString, reason: String) {
        self.amount = amount
        self.category = category
        self.id = id

        self.reason = reason
    }
    
    // Function to save or update the misconduct report in Firestore
    func savePointTodb() {
        print(
        "pt amt: \(amount), category: \(category), id: \(id), reason: \(reason)"
        )
        let db = Firestore.firestore()
        db.collection("points").document(id).setData(toDictionary()) { error in
            if let error = error {
                print("Error saving Point data: \(error.localizedDescription)")
            } else {
                print("Point data saved successfully")
            }
        }
    }
    
    // Function to encode model into a dictionary if needed for custom operations
    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "pointID": id,
            "amount": amount,
            "category": category.rawValue,
            "reason" : reason
        ]
        return dict
    }

    func updatePointsForStudentWithQuery(studentID: Int, completion: @escaping (Bool, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error finding student: \(error.localizedDescription)")
                completion(false, error)
                return
            }
            
            guard let document = querySnapshot?.documents.first else {
                print("No student found with ID: \(studentID)")
                completion(false, nil)
                return
            }
            
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
                
                // Determine new total based on point category
                let pointsChange = self.category == .merit ? self.amount : -self.amount
                let newTotal = existingPoints + pointsChange
                
                // Update the total points for the student.
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
    
    static func fetchPointbyID(by pointID: String, completion: @escaping (PointModel?) -> Void) {
            let db = Firestore.firestore()
            db.collection("points").whereField("pointID", isEqualTo: pointID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching student data: \(error.localizedDescription)")
                    completion(nil)
                } else if let document = snapshot?.documents.first{ // Assuming studentID is unique
                    do {
                        let pointData = try document.data(as: PointModel.self)
                        // print("Fetched student name: \(studentData.fullname)")
                        completion(pointData)
                    } catch {
                        print("Error decoding student data: \(error)")
                        completion(nil)
                    }
                } else if let documents = snapshot?.documents, documents.isEmpty {
                    print("No documents found with pointID: \(pointID)")
                    completion(nil)
                }
                    else {
                        // print("something happened")
                        completion(nil)
                }
            }
        }

}

class Merit : Identifiable, Codable, ObservableObject{
    var id: String
    var pointID: String
    var studentID: Int
    var qrcodeID: String
    var dateScanned: Date
    
    init(pointID: String ,studentID: Int, id: String = UUID().uuidString, qrcodeID: String, dateScanned: Date) {
        self.pointID = pointID
        self.studentID = studentID
        self.id = id
        self.qrcodeID = qrcodeID
        self.dateScanned = dateScanned
    }
    
    func saveMeritToDb() {
        print(
        "pt id: \(pointID), studentID: \(studentID), id: \(id)"
        )
        let db = Firestore.firestore()
        db.collection("merit_points").document(id).setData(toDictionary()) { error in
            if let error = error {
                print("Error saving Merit data: \(error.localizedDescription)")
            } else {
                print("Merit data saved successfully")
            }
        }
        print("Saving merit with pointID: \(pointID), studentID: \(studentID), meritPointsID: \(id)")
    }
    
    // Function to encode model into a dictionary if needed for custom operations
    func toDictionary() -> [String: Any] {
        let dict: [String: Any] = [
            "pointID": pointID,
            "studentID": studentID,
            "meritpointsID": id,
            "dateScanned": dateScanned,
            "qrcodeID": qrcodeID
        ]
        return dict
    }
    
    func fetchStudent(completion: @escaping (DocumentSnapshot?, Error?) -> Void) {
            let db = Firestore.firestore()
            
            // Assuming 'studentID' field is stored as a number in Firestore
            // Adjust the query if 'studentID' is stored as a string or other type
        db.collection("student").whereField("studentID", isEqualTo: self.studentID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching student: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents, !documents.isEmpty else {
                    print("No student found with ID: \(self.studentID)")
                    completion(nil, nil)
                    return
                }
                
                // Assuming each studentID is unique, thus returning the first document
                let studentDocument = documents.first
                completion(studentDocument, nil)
            }
        }
    
    static func fetchAllMerits(completion: @escaping ([Merit]?, Error?) -> Void) {
            let db = Firestore.firestore()
            db.collection("merit_points").getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching merits: \(error.localizedDescription)")
                    completion(nil, error)
                    return
                }
                
                guard let documents = snapshot?.documents else {
                    print("No merits found")
                    completion(nil, nil)
                    return
                }
                
                var merits: [Merit] = []
                for document in documents {
                    if let merit = documentToMerit(document: document) {
                        merits.append(merit)
                    }
                }
                print("there are \(merits.count) merits found")
                completion(merits, nil)
            }
        }
    
    // Helper function to convert a Firestore document to a Merit object
        private static func documentToMerit(document: QueryDocumentSnapshot) -> Merit? {
            let data = document.data()
            guard let pointID = data["pointID"] as? String,
                  let studentID = data["studentID"] as? Int,
                  let id = data["meritpointsID"] as? String,
                  let qrcodeID = data["qrcodeID"] as? String,
                  let dateScannedTimestamp = data["dateScanned"] as? Timestamp else {
                print("Error parsing document to Merit")
                return nil
            }
            
            let dateScanned = dateScannedTimestamp.dateValue()
            
            return Merit(pointID: pointID, studentID: studentID, id: id, qrcodeID: qrcodeID, dateScanned: dateScanned)
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
                        // print("Fetched student name: \(studentData.fullname)")
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
    
    static func fetchStudentbyID(by studentID: Int, completion: @escaping (Student?) -> Void) {
            let db = Firestore.firestore()
            db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching student data: \(error.localizedDescription)")
                    completion(nil)
                } else if let document = snapshot?.documents.first{ // Assuming studentID is unique
                    do {
                        let studentData = try document.data(as: Student.self)
                        print("Fetched student name: \(studentData.fullname)")
                        completion(studentData)
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
}
