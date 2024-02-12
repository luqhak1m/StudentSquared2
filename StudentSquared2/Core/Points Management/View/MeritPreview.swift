//
//  MeritPreview.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 08/02/2024.
//

import SwiftUI
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

struct MeritPreview: View {
    @State private var scannedQR: [Merit] = []
    @State private var students: [Int: Student] = [:]// Maps student IDs to names
    @State private var points: [String: PointModel] = [:]// Maps student IDs to names
    @State private var errorOccurred: Bool = false
    @State private var isLoading: Bool = true
    @EnvironmentObject var viewModel: AuthViewModel

    var body: some View {
        ScrollView {
            LazyVStack {
                if isLoading {
                    ProgressView()
                } else if errorOccurred {
                    Text("Error loading reports.")
                } else {
                    
                    ForEach(scannedQR){ merit in
                        
                        CardViewMerit(
                            category: points[merit.pointID]?.reason ?? "cannot find category",
                            date: formatDate(merit.dateScanned),
                            pointsAddition: points[merit.pointID]?.amount ?? 0,
                            studentID: merit.studentID,
                            details: "nanti aku tambah",
                            student: students[merit.studentID] ?? Student(id: "223123", studentID: 5, password: "123", fullname: "ABC", email: "a@gmail.com", year: 2, course: "A", userType: .student, points: 10),
                            onAccept: {
                                if let point = points[merit.pointID] {
                                    let studentID = merit.studentID // Assuming this is the correct ID you want to use
                                    
                                    //save activity to activity log
                                    logActivityForPointsAddition(studentID: studentID, points: point.amount)

                                    //update points
                                    point.updatePointsForStudentWithQuery(studentID: studentID, completion: { (success, error) in
                                        if success {
                                            merit.updateAcceptedStatus(accepted: true, completion: { (success) in
                                                if(success){
                                                    loadMerits()
                                                }
                                            })
                                            print("Points successfully updated for student ID \(studentID).")
                                        } else if let error = error {
                                            print("Error updating points for student ID \(studentID): \(error.localizedDescription)")
                                        }
                                    })
                                }
                            }, onDecline: {
                                if let point = points[merit.pointID] {
                                    Merit.removeMerit(by: merit.id){success,error in
                                        if (error != nil) == true{
                                            
                                        }else if success{
                                            PointModel.removePoint(by: point.id){_,_ in
                                                loadMerits()
                                            }
                                        }
                                    }
                                }
                            })
                        
                    }
                }
            }
        }
        .onAppear {
            loadMerits()

        }
    }
    
    
    private func formatDate(_ date: Date) -> String {
        // Format the date as needed for your display
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    
    private func loadMerits() {
        print("Loading merits...")
        if let staff = viewModel.currentStaff, viewModel.currentUser?.userType == .staff{
            Merit.fetchAllMerits(staff: staff) { merits, error in
                if let merits = merits {
                    DispatchQueue.main.async {
                        self.scannedQR = merits
                        self.isLoading = false // Ensure to stop loading indicator
                    }
                    self.fetchStudentsAndPointsForMerits(merits)
                } else if let error = error {
                    DispatchQueue.main.async {
                        self.errorOccurred = true
                        self.isLoading = false
                        print("Error fetching merits: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
    
    private func fetchStudentsAndPointsForMerits(_ merits: [Merit]) {
        for merit in merits {
            fetchStudentByID(merit.studentID)
            fetchPointByID(merit.pointID)
        }
    }
    
    private func fetchStudentByID(_ studentID: Int) {
        Merit.fetchStudentbyID(by: studentID) { student in
            DispatchQueue.main.async {
                if let student = student {
                    self.students[studentID] = student
                } else {
                    self.errorOccurred = true
                }
            }
        }
    }
    
    private func fetchPointByID(_ pointID: String) {
        PointModel.fetchPointbyID(by: pointID) { point in
            DispatchQueue.main.async {
                if let point = point {
                    self.points[pointID] = point
                    print("\(point.reason)")
                } else {
                    self.errorOccurred = true
                }
            }
        }
    }

    // Function to log the activity of adding points
    func logActivityForPointsAddition(studentID: Int, points: Int) {
        let db = Firestore.firestore()
        db.collection("student").whereField("studentID", isEqualTo: studentID).getDocuments { (snapshot, error) in
            if let error = error {
                print("Error finding student with ID \(studentID): \(error.localizedDescription)")
                return
            }
            
            guard let document = snapshot?.documents.first else {
                print("No student found with ID: \(studentID)")
                return
            }
            
            guard let userID = document.data()["id"] as? String else {
                print("No user ID found for student with ID \(studentID)")
                return
            }
            
            let activityLog = ActivityLogModel(id: userID, activityID: UUID().uuidString, action: "Added \(points) points", date: Timestamp())
            activityLog.saveActivity()
        }
    }
}

struct CardViewMerit: View {
    var category: String
    var date: String // You can also use Date type and format it within the view
    var pointsAddition: Int
    var studentID: Int
    var details: String
    var student: Student
    var onAccept: (() -> Void)?
    var onDecline: (() -> Void)?

    
    // var evidence:
    @State var showDetails = false
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(student.fullname)
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                    .foregroundColor(.black)
                Text(category)
                    .font(Font.custom("Outfit", size: 12).weight(.semibold))
                    .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                Text(date)
                    .font(Font.custom("Outfit", size: 12).weight(.semibold))
                    .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                Button(action: {
                    // Your action here
                    showDetails.toggle()
                }) {
                    Text("More Details")
                        .font(Font.custom("Outfit", size: 15).weight(.semibold))
                        .underline()
                        .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
                }
            }

            Spacer()

            VStack(spacing: 10) {
                Text("\("+")\(pointsAddition) Points")
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(.black)

                VStack(spacing: 10) {
                    Button("Accept") {
                        
                    
                       onAccept?() // Call the closure here
                    
                    }
                    .frame(width: 103, height: 28)
                    .foregroundColor(.white)
                    .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                    .cornerRadius(14)

                    Button("Decline") {
                        onDecline?() // Call the closure here
                        
                        if let currentUser = viewModel.currentUser {
                            let userID = currentUser.id
                            let actionDescription = "Declined \(pointsAddition) points for \(studentID)"
                            let activityLog = ActivityLogModel(id: userID, action: actionDescription, date: Timestamp())
                            activityLog.saveActivity()
                        } else {
                            // Handle the case where the current user is nil or doesn't have an ID
                            print("Current user is nil or doesn't have an ID")
                        }

                        
                    }
                    .frame(width: 103, height: 28)
                    .foregroundColor(.white)
                    .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                    .cornerRadius(14)
                }
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .stroke(Color.black.opacity(0.1), lineWidth: 1)
        )
        .padding(.horizontal)
    }
}


