//
//  ActivityLogModel.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 10/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class ActivityLogModel: Identifiable, Codable, ObservableObject {
    var activityID : String //id of the action
    var action: String //action
    @ServerTimestamp var date: Timestamp? // Timestamp of the action
    var id: String //userID
    
    init(id: String,
         activityID : String = UUID().uuidString, //id of the action
         action: String, //action
         date: Timestamp? = nil) {
        self.id = id
        self.activityID = activityID
        self.action = action
        self.date = date
    }
    
    func saveActivity() {
            do {
                let db = Firestore.firestore()
                var ref: DocumentReference? = nil
                ref = try db.collection("activity_log").addDocument(from: self) { error in
                    if let error = error {
                        print("Error adding activity: \(error)")
                    } else {
                        print("Activity added with ID: \(ref!.documentID)")
                    }
                }
            } catch {
                print("Error encoding activity log: \(error.localizedDescription)")
            }
    }
    
    static func fetchActivityLogs(forUserID id: String, completion: @escaping ([ActivityLogModel]?, Error?) -> Void) {
        let db = Firestore.firestore()
        db.collection("activity_log")
            .whereField("id", isEqualTo: id)
            .getDocuments { (querySnapshot, error) in
                if let error = error {
                    completion(nil, error)
                } else {
                    var activityLogs: [ActivityLogModel] = []
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        // Ensure the document belongs to the specified user
                        do {
                            let activityLog = try ActivityLogModel(
                                id: data["id"] as? String ?? "",
                                activityID: data["activityID"] as? String ?? "",
                                action: data["action"] as? String ?? "",
                                date: data["date"] as? Timestamp
                            )
                            activityLogs.append(activityLog)
                        } catch {
                            print("Error decoding activity log: \(error.localizedDescription)")
                        }
                    }
                    if activityLogs.isEmpty {
                        completion(nil, nil) // No activity logs found for the specified user
                        print("No Activity Logs Available")
                    } else {
                        completion(activityLogs, nil)
                    }
                }
        }
    }
}
