//
//  UserListView.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 11/02/2024.
//

import SwiftUI
import Firebase

struct UserListView: View {
    @State private var students: [Student] = []
    @State private var staffMembers: [Staff] = []
    @State private var searchText = ""
    @State private var selectedUserType: UserType? = nil // Added state variable for selected user type

    private let db = Firestore.firestore()
    
    var body: some View {
        VStack(spacing: 20) {
            ZStack() {
                Rectangle() //upper purple rectangle with arch
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 122.89)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .cornerRadius(40)
                    .offset(x: 0, y: 0)
                
                Rectangle() //purple white rectangle
                    .foregroundColor(.clear)
                    .frame(width: 390, height: 90)
                    .background(Color(red: 0.92, green: 0.90, blue: 0.97))
                    .offset(x: 0, y: 50)
                
                Text("User List") //title
                    .font(Font.custom("Raleway", size: 20))
                    .foregroundColor(.black)
                    .offset(x: -130, y: -10)
                
                SearchBar(text: $searchText) // Add the SearchBar component
                    .offset(x: 5, y: 35)
                
            }
            .frame(width: 390, height: 122.89) // Adjust the height of the ZStack
            
            List(filteredUsers, id: \.id) { user in
                NavigationLink(destination: UserActivityLogView(userID: user.id)) {
                    HStack {
                        Text(user.fullname)
                        Spacer()
                        if user.userType == .staff {
                            if let staffMember = staffMembers.first(where: { $0.id == user.id }) {
                                Text(staffMember.position)
                            }
                        } else {
                            Text(user.userType == .student ? "Student" : "Staff")
                        }
                    }
                }
            }
            .navigationTitle("User List")
            .onAppear {
                fetchUsers()
            }
        }
    }
    
    // Combined array of users
    private var filteredUsers: [User] {
        let studentsAsUsers = students.map { User(id: $0.id, fullname: $0.fullname, email: "", userType: .student) }
        let staffMembersAsUsers = staffMembers.map { User(id: $0.id, fullname: $0.fullname, email: "", userType: .staff) }
        var filteredArray = (studentsAsUsers + staffMembersAsUsers)
        if let userType = selectedUserType {
            filteredArray = filteredArray.filter { $0.userType == userType }
        }
        return filteredArray.filter { user in
            searchText.isEmpty || user.fullname.localizedCaseInsensitiveContains(searchText)
        }
    }

    private func fetchUsers() {
        fetchStudents()
        fetchStaffMembers()
    }
    
    private func fetchStudents() {
        db.collection("student").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching students: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                students = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Student.self)
                }
            }
        }
    }
    
    private func fetchStaffMembers() {
        db.collection("staff").getDocuments { querySnapshot, error in
            if let error = error {
                print("Error fetching staff members: \(error)")
            } else {
                guard let documents = querySnapshot?.documents else {
                    print("No documents")
                    return
                }
                staffMembers = documents.compactMap { queryDocumentSnapshot in
                    try? queryDocumentSnapshot.data(as: Staff.self)
                }
            }
        }
    }
}

// SearchBar component
struct SearchBar: View {
    @Binding var text: String

    var body: some View {
        HStack {
            TextField("Search", text: $text)
                .padding(.horizontal, 20)
                .padding(.vertical, 10)
                .background(Color.white)
                .cornerRadius(10)
                .padding(.horizontal, 10)

            Spacer()
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
                .padding()
                .offset(x:-17)
        }
    }
}

#Preview {
    UserListView()
}

