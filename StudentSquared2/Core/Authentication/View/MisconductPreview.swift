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
                            pointsDeduction: report.demeritPoints ?? 0
                        )
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
                if let reports = reports {
                    self.misconductReports = reports
                    self.isLoading = false
                    completion() // Call the completion handler after reports are fetched
                } else {
                    print(error?.localizedDescription ?? "Unknown error")
                    self.errorOccurred = true
                    self.isLoading = false
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
                Text("More Details")
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .underline()
                    .foregroundColor(Color(red: 0.60, green: 0.60, blue: 0.60))
            }

            Spacer()

            VStack(spacing: 10) {
                Text("\(pointsDeduction > 0 ? "-" : "+")\(pointsDeduction) Points")
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(.black)

                VStack(spacing: 10) {
                    Button("Accept") {
                        // Handle accept action
                    }
                    .frame(width: 103, height: 28)
                    .foregroundColor(.white)
                    .background(Color(red: 0.46, green: 0.36, blue: 0.73))
                    .cornerRadius(14)

                    Button("Decline") {
                        // Handle decline action
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


#Preview {
    MisconductPreview()
}
