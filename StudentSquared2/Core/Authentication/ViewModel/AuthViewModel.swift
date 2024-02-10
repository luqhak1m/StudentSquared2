//
//  AuthViewModel.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 05/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

enum RegistrationError: Error {
    case missingStudentDetails
    case missingStaffDetails
    
    var localizedDescription: String {
        switch self {
        case .missingStudentDetails:
            return "Missing required student details."
        case .missingStaffDetails:
            return "Missing required staff details."
        }
    }
}

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var currentStudent: Student?
    @Published var currentStaff: Staff?
    @Published var isUserSignedOut = false // Add a flag to track user sign-out
    @Published var isUserRegistered: Bool = false
    
    init() {
        self.userSession = Auth.auth().currentUser
        Task {
            // Fetch user data
            await fetchUser()
            // Check if the user is a student or staff
            /*if let uid = self.userSession?.uid {
                let studentDocument = Firestore.firestore().collection("students").document(uid)
                let staffDocument = Firestore.firestore().collection("staff").document(uid)
                
                let studentSnapshot = try await studentDocument.getDocument()
                let isStudent = studentSnapshot.exists
                
                // Fetch user data based on user type
                if isStudent {
                    await fetchStudent()
                } else {
                    await fetchStaff()
                }
            } else {
                print("User session is nil.")
            }*/
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            // Fetch user data after sign in
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
        /*do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            
            // Get the UID of the current user
            guard let uid = Auth.auth().currentUser?.uid else {
                print("Failed to get UID of the current user.")
                return
            }
            
            // Check if the user is a student or staff
            let studentDocument = Firestore.firestore().collection("students").document(uid)
            let staffDocument = Firestore.firestore().collection("staff").document(uid)
           
            let studentSnapshot = try await studentDocument.getDocument()
            let isStudent = studentSnapshot.exists
            
            // Fetch user data based on user type
            if isStudent {
                await fetchStudent()
            } else {
                await fetchStaff()
            }
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }*/
    }

    
    func createUser(withEmail email: String, password: String, fullname: String, userType: UserType, studentID: Int?, year: Int?, course: String?, staffID: Int?, position: String?, faculty: String?) async throws {
        do {
            // Create user based on userType
            let result = try await Auth.auth().createUser(withEmail: email, password: password) // Firebase generic user
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, userType: userType) //user in app w additional infos
            let encodedUser = try Firestore.Encoder().encode(user) //utilize protocol
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //store to firebase, encodedUser = user
            
            // Create user in Firestore based on userType
            switch userType {
            case .student:
                guard let studentID = studentID, let year = year, let course = course else {
                    throw RegistrationError.missingStudentDetails
                }
                let student = Student(id: result.user.uid, studentID: studentID, password: password, fullname: fullname, email: email, year: year, course: course, userType: userType, points: 0) // Assuming 'points' is now part of Student
                let encodedStudent = try Firestore.Encoder().encode(student)
                try await Firestore.firestore().collection("student").document(student.id).setData(encodedStudent)
                print("Storing student data..")
                //await fetchStudent()
            case .staff:
                guard let staffID = staffID, let position = position, let faculty = faculty else {
                    throw RegistrationError.missingStaffDetails
                }
                let staff = Staff(id: result.user.uid, staffID: staffID, password: password, fullname: fullname, email: email, position: position, faculty: faculty, userType: userType)
                let encodedStaff = try Firestore.Encoder().encode(staff)
                try await Firestore.firestore().collection("staff").document(staff.id).setData(encodedStaff)
                print("Storing staff data..")
                
                // Check if the staff's position is a lecturer or an admin
                switch position.lowercased() {
               case "lecturer":
                   // Store the staff ID in the "lecturers" collection
                   try await Firestore.firestore().collection("lecturer").document(staff.id).setData(["staffID": staffID])
                   print("Storing lecturer data..")
               case "admin":
                   // Store the staff ID in the "admins" collection
                   try await Firestore.firestore().collection("admin").document(staff.id).setData(["staffID": staffID])
                   print("Storing admin data..")
               default:
                   break // Do nothing for other positions
               }
            }
            // Fetch user data
            //await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
    /*func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //firebase generic user
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email, userType: .staff) //user in app w additional infos
            let encodedUser = try Firestore.Encoder().encode(user) //utilize protocol
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //store to firebase, encodedUser = user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }*/
    
    
    func signOut(){
        do {
            try Auth.auth().signOut() //signs out user in backend
            self.userSession = nil //wipes out user session
            self.currentUser = nil//wipes out current user data model
            print("DEBUG: Sign out successful")
        } catch {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
    func deleteAccount(){
        print("look ma")
    }
    
    func fetchUser() async {
        print("Fetching user data...")
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user is currently authenticated.")
            return
        }

        let studentDocument = Firestore.firestore().collection("student").document(uid)
        let staffDocument = Firestore.firestore().collection("staff").document(uid)
        
        do {
            let studentSnapshot = try await studentDocument.getDocument()
            let staffSnapshot = try await staffDocument.getDocument()
            
            if studentSnapshot.exists {
                do {
                    let studentData = try studentSnapshot.data(as: Student.self)
                    let student = studentData
                    self.currentUser = User(id: student.id, fullname: student.fullname, email: student.email, userType: .student)
                    self.currentStudent = student
                    print("Current user is a student: \(student)")
                    return
                } catch {
                    print("Error parsing student data: \(error.localizedDescription)")
                }
            }
            
            if staffSnapshot.exists {
                do {
                    let staffData = try staffSnapshot.data(as: Staff.self)
                    let staff = staffData
                    self.currentUser = User(id: staff.id, fullname: staff.fullname, email: staff.email, userType: .staff)
                    self.currentStaff = staff
                    print("Current user is a staff: \(staff)")
                    return
                } catch {
                    print("Error parsing staff data: \(error.localizedDescription)")
                }
            }
            
            print("User data not found.")
            forceSignOutUser()
            //self.currentUser = nil
        } catch {
            print("Error fetching user data: \(error.localizedDescription)")
        }
    }

    
    /*func fetchUser() async {
        if let currentUser = self.currentUser {
            print("DEBUG: Current user is \(currentUser)")
        } else {
            print("DEBUG: Current user is nil")
        }
        print("Fetching user data...")
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // Check if the user is a student or staff
        let staffDocument = Firestore.firestore().collection("staff").document(uid)
        let studentDocument = Firestore.firestore().collection("student").document(uid)
        
        let studentSnapshot = try? await studentDocument.getDocument()
        let isStudent = studentSnapshot?.exists ?? false
        
        if isStudent {
            await fetchStudent()
        } else {
            await fetchStaff()
        }
    }*/

    func fetchStudent() async {
        print("Fetching student data...")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Assuming student data is stored in a "students" collection
        guard let snapshot = try? await Firestore.firestore().collection("students").document(uid).getDocument() else { return }
        self.currentStudent = try? snapshot.data(as: Student.self)
    }

    func fetchStaff() async {
        print("Fetching staff data...")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Assuming staff data is stored in a "staff" collection
        guard let snapshot = try? await Firestore.firestore().collection("staff").document(uid).getDocument() else { return }
        self.currentStaff = try? snapshot.data(as: Staff.self)
    }

    // Call this function wherever you want to force sign out the user
    func forceSignOutUser() {
        do {
            try Auth.auth().signOut()
            self.userSession = nil
            self.currentUser = nil
            self.currentStudent = nil
            self.currentStaff = nil
            self.isUserSignedOut = true
        } catch let signOutError as NSError {
            print("Error signing out: \(signOutError)")
        }
    }
    
    // Fetch user function for students
    /*func fetchStudent() async {
        print("Fetching student data...")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Assuming student data is stored in a "students" collection
        guard let snapshot = try? await Firestore.firestore().collection("students").document(uid).getDocument() else { return }
        self.currentStudent = try? snapshot.data(as: Student.self) as Student?
    }

    // Fetch user function for staff
    func fetchStaff() async {
        print("Fetching staff data...")
        print("DEBUG: Current user is \(self.currentUser)")
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        // Assuming staff data is stored in a "staff" collection
        guard let snapshot = try? await Firestore.firestore().collection("staff").document(uid).getDocument() else { return }
        self.currentStaff = try? snapshot.data(as: Staff.self) as Staff?
    }

    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }

        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        //print("DEBUG: Current user is \(self.currentUser)")
    }*/


}
