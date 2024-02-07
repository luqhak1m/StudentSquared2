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
    var reportID: Int? // Unique identifier for each QR code instance
    var misconductType: String
    var date: Timestamp // Using Timestamp for Firestore compatibility
    var studentID: Int?
    var details: String
    var demeritPoints: Int?
    var agreement1: Bool=false
    var agreement2: Bool=false
    var accepted: Bool=false
    // Optional: Image URL if storing image references in Firestore
    var imageURL: String?
    
    // Initialize the MisconductReportModel with all properties
    init(misconductType: String,
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
        self.reportID = 0
        // self.imageURL = imageURL
    }
    
    // Function to save or update the misconduct report in Firestore
    func saveOrUpdateMisconductReport() {
        let db = Firestore.firestore()
        db.collection("misconduct").addDocument(data: toDictionary()) { error in
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
            "accepted" : accepted,
        ]
        
        // Only add studentID and points if they are not nil
           if let studentID = studentID {
               dict["studentID"] = studentID
           }
           if let points = demeritPoints {
               dict["demeritPoints"] = points
           }
           if let reportID = reportID {
               dict["reportID"] = reportID
           }
        
        return dict
    }
    
    // Static function to fetch all misconduct reports
    static func fetchAllMisconductReports(completion: @escaping ([MisconductReportModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("misconduct").getDocuments { (snapshot, error) in
            if let error = error {
                print("Error fetching misconduct reports: \(error.localizedDescription)")
                completion(nil, error)
            } else {
                let reports = snapshot?.documents.compactMap { document -> MisconductReportModel? in
                    try? document.data(as: MisconductReportModel.self)
                }
                completion(reports, nil)
            }
        }
    }
    
    static func fetchStudentName(by studentID: Int, completion: @escaping (String?) -> Void) {
        print("it runs")
            let db = Firestore.firestore()
            db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (snapshot, error) in
                if let error = error {
                    print("Error fetching student data: \(error.localizedDescription)")
                    completion(nil)
                } else if let document = snapshot?.documents.first{ // Assuming studentID is unique
                    print("hello")
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
                        print("something happened")
                        completion(nil)
                }
            }
        }
}

