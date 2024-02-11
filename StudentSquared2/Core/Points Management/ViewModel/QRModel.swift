//
//  QRModel.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 07/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class QRCodeModel: Identifiable, Codable, ObservableObject {
    var id: String // Unique identifier for each QR code instance
    var category: String
    var points: Int
    var startDate: Date
    var endDate: Date
    var startTime: Date
    var endTime: Date
    var remarks: String
    var staffID: Int
    
    // Initialize the QRCodeModel with all properties
    init(id: String = UUID().uuidString, category: String, points: Int, startDate: Date, endDate: Date, startTime: Date, endTime: Date, remarks: String, staffID: Int) {
        self.id = id
        self.category = category
        self.points = points
        self.startDate = startDate
        self.endDate = endDate
        self.startTime = startTime
        self.endTime = endTime
        self.remarks = remarks
        self.staffID = staffID
    }
    
    // A computed property to generate the string to encode in the QR code
    var encodedString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy"
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        
        return """
        Category: \(category), Points: \(points), Start Date: \(dateFormatter.string(from: startDate)), End Date: \(dateFormatter.string(from: endDate)), Start Time: \(timeFormatter.string(from: startTime)), End Time: \(timeFormatter.string(from: endTime)), Remarks: \(remarks)
        """
    }
    
    func saveQRCodeDataToFirestore() {
        print("executed!!!")
        let db = Firestore.firestore()

        // Convert dates and times to Timestamps
        let startDateTimestamp = Timestamp(date: startDate)
        let endDateTimestamp = Timestamp(date: endDate)
        let startTimeTimestamp = Timestamp(date: Calendar.current.startOfDay(for: startDate).addingTimeInterval(startTime.timeIntervalSince1970.truncatingRemainder(dividingBy: 86400)))
        let endTimeTimestamp = Timestamp(date: Calendar.current.startOfDay(for: endDate).addingTimeInterval(endTime.timeIntervalSince1970.truncatingRemainder(dividingBy: 86400)))

        let qrCodeData: [String: Any] = [
            "qrcodeID": id,
            "category": category,
            "points": points,
            "start date": startDateTimestamp,
            "end date": endDateTimestamp,
            "start time": startTimeTimestamp,
            "end time": endTimeTimestamp,
            "remark": remarks,
            "staffID": staffID // Ensure this field exists in your Firestore document model
        ]

        // Use `document(id)` to explicitly set the document ID
        db.collection("qr-data").document(id).setData(qrCodeData) { error in
            if let error = error {
                print("Error saving QR code data: \(error.localizedDescription)")
            } else {
                print("QR code data saved successfully with matching ID")
            }
        }
    }
    
    static func matchScannedQRCodeID(with scannedID: String, completion: @escaping (QRCodeModel?, Error?) -> Void) {
        let db = Firestore.firestore()
        
        db.collection("qr-data").whereField("qrcodeID", isEqualTo: scannedID).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error finding QR code data: \(error.localizedDescription)")
                completion(nil, error)
            } else if let querySnapshot = querySnapshot, !querySnapshot.isEmpty {
                guard let document = querySnapshot.documents.first else {
                    print("No matching QR code found")
                    completion(nil, nil)
                    return
                }
                
                let data = document.data()
                
                guard let id = data["qrcodeID"] as? String,
                      let category = data["category"] as? String,
                      let points = data["points"] as? Int,
                      let startDateTimestamp = data["start date"] as? Timestamp,
                      let endDateTimestamp = data["end date"] as? Timestamp,
                      let startTimeTimestamp = data["start time"] as? Timestamp,
                      let endTimeTimestamp = data["end time"] as? Timestamp,
                      let remarks = data["remark"] as? String,
                      let staffID = data["staffID"] as? Int else {
                          print("Error decoding QR code data")
                          completion(nil, nil)
                          return
                      }
                
                let qrCodeModel = QRCodeModel(
                    id: id,
                    category: category,
                    points: points,
                    startDate: startDateTimestamp.dateValue(),
                    endDate: endDateTimestamp.dateValue(),
                    startTime: startTimeTimestamp.dateValue(),
                    endTime: endTimeTimestamp.dateValue(),
                    remarks: remarks,
                    staffID: staffID
                )
                
                completion(qrCodeModel, nil)
            } else {
                print("No matching QR code found")
                completion(nil, nil)
            }
        }
    }
}






