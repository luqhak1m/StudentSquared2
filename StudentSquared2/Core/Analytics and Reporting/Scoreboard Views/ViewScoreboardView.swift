//
//  ViewScoreboardView.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 11/02/2024.
//

import SwiftUI
import Firebase

struct ViewScoreboardView: View {
    @State private var topStudents: [Student] = [] // top 3 students
    @State private var otherStudents: [Student] = [] // other students
    
    private let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack() {
                Rectangle() //upper purple rectangle with arch
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 262.89)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .cornerRadius(40)
                    .offset(x: 0, y: -0.56)
                
                Rectangle() //bottom white rectangle
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 200)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .offset(x: 0, y: 81.89)
                
                Text("Scoreboard") //title
                    .font(Font.custom("Raleway", size: 20))
                    .foregroundColor(.black)
                    .offset(x: -120, y: -88)
                
                ForEach(Array(zip(topStudents.indices, topStudents)), id: \.0) { index, student in
                    let place = index + 1
                    let yOffset = CGFloat(index) * 50
                    let xOffset = place == 1 ? 0 : (place == 2 ? -124.50 : 124.50)
                    
                    ZStack() {
                        Rectangle() // Place rectangle
                            .foregroundColor(.clear)
                            .frame(width: 113, height: 167)
                            .background(.white)
                            .cornerRadius(40)
                            .offset(x: 0.50 + xOffset, y: 20) // Adjust vertical and horizontal offset
                            .shadow(
                                color: Color(red: 0, green: 0, blue: 0, opacity: 0.25), radius: 4, y: 4
                            )
                        
                        // Display trophy, student info, and points here
                        Image("Trophy")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 80, height: 80) // Set specific dimensions for the trophy
                            .offset(x: xOffset)
                        
                        Rectangle() //circle
                            .foregroundColor(Color(red: 1, green: 0.87, blue: 0.55))
                            .frame(width: 48.09, height: 48.09) // Adjust the width and height as needed
                            .cornerRadius(24.045) // Half of the width or height to make it a circle
                            .offset(x: 0 + xOffset, y: -70)
                        
                        Text("\(place)")
                            .font(Font.custom("Outfit", size: 20))
                            .foregroundColor(.black)
                            .offset(x: 0.45 + xOffset, y: -70)
                        
                        Text("\(student.fullname)")  // Student ID
                            .font(Font.custom("Outfit", size: 13))
                            .foregroundColor(.black)
                            .offset(x:xOffset, y: 50)
                        
                        Text("Points : \(student.points)") // Student points
                            .font(Font.custom("Outfit", size: 10))
                            .foregroundColor(Color(red: 0.50, green: 0.50, blue: 0.50))
                            .offset(x: 2.50 + xOffset, y: 70)
                    }
                    .frame(width: 80, height: 61)
                    .offset(x: 0, y: 50)
                }
            }
            .frame(width: 390, height: 244)
            
            ScrollView {
                VStack(spacing: 20) {
                    ForEach(otherStudents.indices, id: \.self) { index in
                        let student = otherStudents[index]
                        HStack {
                            ZStack {
                                Circle()
                                    .foregroundColor(Color(red: 0.92, green: 0.90, blue: 0.97))
                                    .frame(width: 30, height: 30)
                                Text("\(index + 4)")
                                    .font(Font.custom("Outfit", size: 15))
                                    .foregroundColor(.gray)
                            }
                            .padding()
                            
                            Image("StudentIcon")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                            
                            Text("\(student.fullname)")
                                .font(Font.custom("Outfit", size: 13))
                                .foregroundColor(.black)
                            
                            Spacer()
                            
                            Text("Points: \(student.points)")
                                .font(Font.custom("Outfit", size: 13))
                                .foregroundColor(.black)
                                .frame(maxWidth: .infinity, alignment: .trailing)
                        }
                        .padding()
                        .background(Color.white)
                        .cornerRadius(10)
                        .shadow(radius: 4)
                    }
                }
                .padding()
                .offset(y: 60)
            }
        }
        .padding()
        .onAppear {
            fetchTopStudents()
        }
    }
    
    private func fetchTopStudents() {
        db.collection("student")
            .order(by: "points", descending: true)
            .limit(to: 3)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    topStudents = documents.compactMap { queryDocumentSnapshot in
                        try? queryDocumentSnapshot.data(as: Student.self)
                    }
                    
                    // After fetching topStudents, fetch the non-top 3 students
                    fetchNonTop3()
                }
            }
    }
    
    private func fetchNonTop3() {
        db.collection("student")
            .order(by: "points", descending: true)
            .getDocuments { [self] querySnapshot, error in
                if let error = error {
                    print("Error fetching documents: \(error)")
                } else {
                    guard let documents = querySnapshot?.documents else {
                        print("No documents")
                        return
                    }
                    let topStudentIDs = topStudents.map { $0.id }
                    
                    var nonTopStudents: [Student] = []
                    
                    for document in documents {
                        guard let student = try? document.data(as: Student.self) else {
                            continue
                        }
                        // Check if the student's ID is not in the top 3 student IDs
                        if !topStudentIDs.contains(student.id) {
                            nonTopStudents.append(student)
                        }
                    }
                    
                    otherStudents = nonTopStudents
                }
            }
    }
}

struct ViewScoreboardView_Previews: PreviewProvider {
    static var previews: some View {
        ViewScoreboardView()
    }
}
