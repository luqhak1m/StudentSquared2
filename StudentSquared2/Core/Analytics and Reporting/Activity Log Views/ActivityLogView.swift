//
//  ActivityLogView.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 10/02/2024.
//

import SwiftUI

struct ActivityLogView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var activityLogs: [ActivityLogModel] = []

    var body: some View {
        ScrollView {
            LazyVStack(spacing: 20) {
                ForEach(activityLogs, id: \.activityID) { activityLog in
                    ActivityLogCardView(activityLog: activityLog)
                }
            }
            .padding()
        }
        .onAppear {
            if let currentUserID = viewModel.currentUser?.id {
                ActivityLogModel.fetchActivityLogs(forUserID: currentUserID) { logs, error in
                    if let logs = logs {
                        self.activityLogs = logs
                    } else if let error = error {
                        print("Error fetching activity logs: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}

struct ActivityLogCardView: View {
    var activityLog: ActivityLogModel

    var body: some View {
        VStack(alignment: .leading) {
            Text("Activity: \(activityLog.action)")
                .font(.headline)
            if let date = activityLog.date?.dateValue() {
                Text("Date: \(formattedDate(date))")
                    .font(.subheadline)
            }
            Divider()
        }
        .padding()
        .background(Color.white)
        .cornerRadius(12)
        .shadow(radius: 5)
        .padding(.horizontal)
    }
    
    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter.string(from: date)
    }
}
