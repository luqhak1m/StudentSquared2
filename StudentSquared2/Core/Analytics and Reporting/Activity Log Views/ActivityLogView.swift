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

/*struct ActivityLogView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityLogView()
    }
}*/

/*import SwiftUI

struct PersonalActivityLog: View {
  var body: some View {
    ZStack() {
      Group {
        Text("Activity Log")
          .font(Font.custom("Raleway", size: 20))
          .foregroundColor(.black)
          .offset(x: -117.50, y: -339)
        Rectangle()
          .foregroundColor(.clear)
          .frame(width: 636, height: 0)
          .overlay(
            Rectangle()
              .stroke(Color(red: 0.77, green: 0.77, blue: 0.77), lineWidth: 0.50)
          )
          .offset(x: 172, y: -299)
          .rotationEffect(.degrees(-89.82))
          
        ZStack() {
          ZStack() {

          }
          .frame(width: 40, height: 40)
          .offset(x: -67.50, y: 0)
          Text("20 Merit Points Addition")
            .font(Font.custom("Outfit", size: 12))
            .foregroundColor(.black)
            .offset(x: 23.50, y: -4.50)
          Text("on 20-Dec-2023")
            .font(Font.custom("Outfit", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -3, y: 10.50)
        }
        .frame(width: 175, height: 40)
        .offset(x: -77.50, y: -256)
          
        ZStack() {
          ZStack() {

          }
          .frame(width: 40, height: 40)
          .offset(x: -67.50, y: 0)
          Text("30 Merit Points Addition")
            .font(Font.custom("Outfit", size: 12))
            .foregroundColor(.black)
            .offset(x: 23.50, y: -6.50)
          Text("on 18-Dec-2023")
            .font(Font.custom("Outfit", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -3.50, y: 8.50)
        }
        .frame(width: 175, height: 40)
        .offset(x: -77.50, y: -166)
          
        ZStack() {
          ZStack() {

          }
          .frame(width: 40, height: 40)
          .offset(x: -65.50, y: 0)
          Text("15 Merit Points Addition")
            .font(Font.custom("Outfit", size: 12))
            .foregroundColor(.black)
            .offset(x: 23.50, y: -7.50)
          Text("on 18-Dec-2023")
            .font(Font.custom("Outfit", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -1.50, y: 8.50)
        }
        .frame(width: 171, height: 40)
        .offset(x: -79.50, y: -72)
          
        ZStack() {
          ZStack() {

          }
          .frame(width: 40, height: 40)
          .offset(x: -65.50, y: 0)
          Text("15 Merit Points Addition")
            .font(Font.custom("Outfit", size: 12))
            .foregroundColor(.black)
            .offset(x: 23.50, y: -7.50)
          Text("on 20-Nov-2023")
            .font(Font.custom("Outfit", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -1, y: 8.50)
        }
        .frame(width: 171, height: 40)
        .offset(x: -78.50, y: 294)
          
        ZStack() {
          Text("Submitted Misconduct Report")
            .font(Font.custom("Outfit", size: 12))
            .foregroundColor(.black)
            .offset(x: 25, y: -7)
          Text("on 10-Dec-2023")
            .font(Font.custom("Outfit", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -15.50, y: 7)
          ZStack() {

          }
          .frame(width: 47, height: 47)
          .offset(x: -79.50, y: 0)
        }
        .frame(width: 206, height: 47)
        .offset(x: -65, y: 19.50)
          
        ZStack() {
          Text("10 Demerit Points Deduction")
            .font(Font.custom("Outfit", size: 12))
            .foregroundColor(.black)
            .offset(x: 22, y: -5)
          Text("on 8-Dec-2023")
            .font(Font.custom("Outfit", size: 10))
            .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
            .offset(x: -16.50, y: 9)
          ZStack() {

          }
          .frame(width: 37, height: 37)
          .offset(x: -79, y: 0)
        }
        .frame(width: 195, height: 37)
        .offset(x: -65.50, y: 111.50)
          
        ZStack() {
          ZStack() {
            Text("Updated Profile")
              .font(Font.custom("Outfit", size: 12))
              .foregroundColor(.black)
              .offset(x: 0, y: -6.50)
            Text("on 21-Nov-2023")
              .font(Font.custom("Outfit", size: 10))
              .foregroundColor(Color(red: 0.43, green: 0.43, blue: 0.43))
              .offset(x: -6, y: 7.50)
          }
          .frame(width: 84, height: 28)
          .offset(x: 24, y: -2)
          ZStack() {

          }
          .frame(width: 40, height: 40)
          .offset(x: -46, y: 0)
        }
        .frame(width: 132, height: 40)
        .offset(x: -98, y: 204)
      }
        
        Group {
        HStack(spacing: 0) {

        }
        .padding(EdgeInsets(top: 3, leading: 4, bottom: 3, trailing: 4))
        .frame(width: 24, height: 24)
        .offset(x: 159, y: -299)
      }
    }
    .frame(width: 390, height: 844)
    .background(.white);
  }
}

#Preview {
    PersonalActivityLog()
}*/
