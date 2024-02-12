//
//  PointHistoryView.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 10/02/2024.
//

import SwiftUI

struct PointHistoryView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var pointData: [PointData] = [] // Use PointData instances

    var body: some View {
        if let studentID = viewModel.currentStudent?.studentID, viewModel.currentUser?.userType == .student {
            ScrollView {
                ForEach(pointData) { item in
                    PointHistory(title: item.title, date: item.date, detail: item.detail, points: item.points)
                }
            }
            .onAppear {
                fetchPointHistory(for: studentID)
            }
        }
    }
    
    private func fetchPointHistory(for studentID: Int) {
        fetchMerits(for: studentID)
        fetchMisconducts(for: studentID)
    }
    
    private func fetchMerits(for studentID: Int) {
        Merit.fetchMeritForStudent(studentID: studentID) { merits in
            for merit in merits {
                PointModel.fetchPointbyID(by: merit.pointID) { pointModel in
                    if let point = pointModel {
                        DispatchQueue.main.async {
                            let formattedDate = DateFormatter.localizedString(from: merit.dateScanned, dateStyle: .medium, timeStyle: .short)
                            self.pointData.append(PointData(title: "Merit: \(point.reason)", date: formattedDate, detail: point.reason, points: String(point.amount)))
                        }
                    }
                }
            }
        }
    }
    
    private func fetchMisconducts(for studentID: Int) {
        MisconductReportModel.fetchMisconductsForStudent(studentID: studentID) { misconducts in
            for misconduct in misconducts {
                PointModel.fetchPointbyID(by: misconduct.pointsID) { pointModel in
                    if let point = pointModel {
                        DispatchQueue.main.async {
                            let formattedDate = DateFormatter.localizedString(from: misconduct.date.dateValue(), dateStyle: .medium, timeStyle: .short)
                            self.pointData.append(PointData(title: "Misconduct: \(point.reason)", date: formattedDate, detail: point.reason, points: String(point.amount)))
                        }
                    }
                }
            }
        }
    }
}

struct PointData: Identifiable {
    let id = UUID()
    var title: String
    var date: String
    var detail: String
    var points: String
}

#Preview {
    PointHistoryView()
}
