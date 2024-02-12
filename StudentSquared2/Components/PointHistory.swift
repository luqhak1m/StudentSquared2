//
//  PointHistory.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 10/02/2024.
//

import SwiftUI

struct PointHistory: View{
    
    var title: String
    var date: String
    var detail: String
    var points: String
    @State private var showSheet: Bool = false
    
    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                    .foregroundColor(.black)
                Text(date)
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
                Text(detail)
                    .font(Font.custom("Outfit", size: 15).weight(.semibold))
                    .foregroundColor(Color(red: 0.41, green: 0.41, blue: 0.41))
            }
            Spacer()
            VStack {
                Text(points)
                    .font(Font.custom("Outfit", size: 30).weight(.semibold))
                    .foregroundColor(.black)
            }
        }
        .padding()
        .background(Color(red: 0.92, green: 0.90, blue: 0.97))
        .cornerRadius(10)
        .onTapGesture {
            self.showSheet = true
        }
        .sheet(isPresented: $showSheet) {
            pointHistoryDetailView()
        }
    }

    // This function now generates the detail view
    // Since it's a function inside PointHistory, it can access the PointHistory variables
    func pointHistoryDetailView() -> some View {
        PointHistoryDetailView(
            studentFullname: "Alex Karev", // Pass the actual data
            studentID: 12004122837,
            dateReported: date,
            demeritCategory: detail,
            detailsOfMisconduct: "Details about the misconduct",
            evidence: "Evidence details",
            demeritPoints: Int(points) ?? 0
        )
    }
}

extension PointHistory {
    struct PointHistoryDetailView: View {
        var studentFullname: String
        var studentID: Int
        var dateReported: String
        var demeritCategory: String
        var detailsOfMisconduct: String
        var evidence: String
        var demeritPoints: Int

        var body: some View {
            // ... (The rest of your PointHistoryDetailView code here)
            VStack {
                Text(studentFullname)
                    .font(Font.custom("Outfit", size: 25).weight(.semibold))
                      .foregroundColor(.black);
                
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
                
                
                VStack(alignment: .leading, spacing: 10) {
                    Text("Student details:")
                        .font(.headline)
                        .foregroundColor(.secondary)
                    HStack {
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Student ID")
                            Divider()
                            Text("Name")
                            Divider()
                            Text("Email")
                            Divider()
                            Text("Year")
                            Divider()
                            Text("Course")
                            Divider()
                            Text("Mentor")
                        }
                        VStack(alignment: .leading, spacing: 10) {
                            Text("studentID")
                            Divider()
                            Text("name")
                            Divider()
                            Text("email")
                            Divider()
                            Text("year")
                            Divider()
                            Text("course")
                            Divider()
                            Text("mentor")
                        }
                    }
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding([.horizontal, .top])
            
                Text("Points:  -\(demeritPoints) Points")
                    .font(Font.custom("Outfit", size: 20).weight(.semibold))
                          .foregroundColor(.black);
            }
            .padding()
            .background(Color.white)
            .cornerRadius(12)
            .shadow(radius: 10)
        }
    }
    
}
