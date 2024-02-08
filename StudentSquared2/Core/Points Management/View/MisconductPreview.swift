//
//  MisconductPreview.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 07/02/2024.
//

import SwiftUI

struct MisconductPreview: View {
    @State private var misconductReports: [MisconductReportModel] = []
    @State private var studentNames: [Int: String] = [:] // Maps student IDs to names
    @State private var errorOccurred: Bool = false
    @State private var isLoading: Bool = true

    var body: some View {
        ScrollView {
            LazyVStack {
                if isLoading {
                    ProgressView()
                } else if errorOccurred {
                    Text("Error loading reports.")
                } else {
                    ForEach(misconductReports) { report in
                        CardView(
                            name: studentNames[report.studentID ?? 0, default: "Unknown Student"],
                            category: report.misconductType,
                            date: formatDate(report.date.dateValue()),
                            pointsDeduction: report.demeritPoints ?? 0,
                            studentID: report.studentID ?? 0,
                            details: report.details,
                            report: report,
                            onAccept: { // Add this closure
                                self.fetchMisconductReports {
                                    self.fetchStudentNamesAndUpdateReports()
                                }
                            })
                    }
                }
            }
        }
        .onAppear {
            fetchMisconductReports{
                fetchStudentNamesAndUpdateReports()
            }
        }
    }
    
    private func fetchMisconductReports(completion: @escaping () -> Void) {
        MisconductReportModel.fetchAllMisconductReports { reports, error in
            DispatchQueue.main.async {
                if let reports = reports {
                    self.misconductReports = reports
                    self.isLoading = false
                    completion()
                } else {
                    print(error?.localizedDescription ?? "Unknown error")
                    self.errorOccurred = true
                    self.isLoading = false
                }
            }
        }
    }
        
    private func formatDate(_ date: Date) -> String {
        // Format the date as needed for your display
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd MMMM yyyy HH:mm"
        return dateFormatter.string(from: date)
    }
    
    private func fetchStudentNamesAndUpdateReports() {
            for report in misconductReports {
                guard let studentID = report.studentID else { continue }
                MisconductReportModel.fetchStudentName(by: studentID) { name in
                    DispatchQueue.main.async {
                        self.studentNames[studentID] = name ?? "Unknown Student"
                    }
                }
            }
        }
}

struct CardView: View {
    var name: String
    var category: String
    var date: String // You can also use Date type and format it within the view
    var pointsDeduction: Int
    var studentID: Int
    var details: String
    var report: MisconductReportModel // Pass the whole report model to the CardView
    // var points: PointModel // Pass the whole report model to the CardView
    var onAccept: (() -> Void)?

    // var evidence:
    @State var showDetails = false
    

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(name)
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
                }.sheet(isPresented: $showDetails, content: {
                    MisconductDetailView(
                                    studentFullname: name,
                                    studentID: studentID,
                                    dateReported: date,
                                    demeritCategory: category,
                                    detailsOfMisconduct: details,
                                    evidence: "cannot display image yet wait ya",
                                    demeritPoints: pointsDeduction
                                )
                })
            }

            Spacer()

            VStack(spacing: 10) {
                Text("\(pointsDeduction > 0 ? "-" : "+")\(pointsDeduction) Points")
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(.black)

                VStack(spacing: 10) {
                    Button("Accept") {
                        
                        report.updateAcceptedStatus(accepted: true) { success in
                           if success {
                               // Handle the UI update or any other logic after the status is updated
                               // print("Accepted status set to true in Firestore")
                               
                           
                           }
                       }
                        let point = PointModel(amount: pointsDeduction, category: .demerit, reason: category)
                        
                        point.updatePointsForStudentWithQuery(studentID: studentID){ success, error in
                            if success {
                                print("Points successfully updated for student.")
                            } else if let error = error {
                                print("Failed to update points: \(error.localizedDescription)")
                            }
                        }
                       onAccept?() // Call the closure here
                    
                    }
                    .frame(width: 103, height: 28)
                    .foregroundColor(.white)
                    .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                    .cornerRadius(14)

                    Button("Decline") {
                        onAccept?() // Call the closure here
                        report.updateAcceptedStatus(accepted: false) { success in
                           if success {
                               // Handle the UI update or any other logic after the status is updated
                               // print("Accepted status set to false in Firestore")
                           
                           } else {
                               // Handle the error case
                               // print("Failed to update the accepted status")
                           }
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

struct MisconductDetailView: View {
    var studentFullname: String
    var studentID: Int
    var dateReported: String
    var demeritCategory: String
    var detailsOfMisconduct: String
    var evidence: String
    var demeritPoints: Int

    var body: some View {
        VStack {
            Text(studentFullname)
                .font(Font.custom("Outfit", size: 25).weight(.semibold))
                  .foregroundColor(.black);
            Text("ID: \(studentID)")
            
            Rectangle()
                  .foregroundColor(.clear)
                  .frame(width: 366, height: 2)
                  .background(Color(red: 0.94, green: 0.94, blue: 0.94))
                  .cornerRadius(6);
            
            Text("Reported on \(dateReported)")
                .font(Font.custom("Outfit", size: 15).weight(.semibold))
                      .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
            Text("Reported for \(demeritCategory)")
                .font(Font.custom("Outfit", size: 15).weight(.semibold))
                      .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
            
            Text("Report Details:")
                  .font(Font.custom("Outfit", size: 15).weight(.semibold))
                  .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.6))
            
            
            Text("\(detailsOfMisconduct)")
                .frame(width: 322, height: 74, alignment: .leading)
                .padding()
                .background(Color.white)
                .cornerRadius(15)
                .shadow(color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4)
                    
            Text("\(evidence)")
                      .frame(width: 322, height: 154)
                      .background(.white)
                      .cornerRadius(15)
                      .shadow(
                        color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                      );
            Text("Suggested Points:  -\(demeritPoints) Points")
                .font(Font.custom("Outfit", size: 20).weight(.semibold))
                      .foregroundColor(.black);
            HStack(spacing: 10) {
                Button("Accept") {
                    
                }
                .frame(width: 92, height: 44)
                .foregroundColor(.white)
                .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                .cornerRadius(12)

                Button("Edit Points") {
                    // Handle decline action
                }
                .frame(width: 92, height: 44)
                .foregroundColor(.white)
                .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                .cornerRadius(12)
                
                Button("Decline") {
                    // Handle decline action
                }
                .frame(width: 92, height: 44)
                .foregroundColor(.white)
                .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                .cornerRadius(12)
            }
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 10)
    }
}

#Preview {
    MisconductPreview()
}
