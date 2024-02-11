//
//  UserActivityLogView.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 11/02/2024.
//

import SwiftUI

struct UserActivityLogView: View {
    let userID: String
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
            fetchActivityLogs()
        }
    }
        
    private func fetchActivityLogs() {
        ActivityLogModel.fetchActivityLogs(forUserID: userID) { logs, error in
            if let logs = logs {
                self.activityLogs = logs
            } else if let error = error {
                print("Error fetching activity logs: \(error.localizedDescription)")
            }
        }
    }
}

/*#Preview {
    UserActivityLogView()
}*/
