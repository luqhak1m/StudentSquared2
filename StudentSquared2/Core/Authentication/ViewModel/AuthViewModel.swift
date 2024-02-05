//
//  AuthViewModel.swift
//  StudentSquared2
//
//  Created by Aisyah Nabila on 05/02/2024.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

@MainActor
class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    init() {
        self.userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    func signIn(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password) //sign in first, before fetching the user from firebase
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to log in with error \(error.localizedDescription)")
        }
    }
    
    func createUser(withEmail email: String, password: String, fullname: String) async throws {
        do {
            let result = try await Auth.auth().createUser(withEmail: email, password: password) //firebase generic user
            self.userSession = result.user
            let user = User(id: result.user.uid, fullname: fullname, email: email) //user in app w additional infos
            let encodedUser = try Firestore.Encoder().encode(user) //utilize protocol
            try await Firestore.firestore().collection("users").document(user.id).setData(encodedUser) //store to firebase, encodedUser = user
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error \(error.localizedDescription)")
        }
    }
    
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
        
    }
    
    func fetchUser() async{
        guard let uid = Auth.auth().currentUser?.uid else { return }

        guard let snapshot = try? await Firestore.firestore().collection("users").document(uid).getDocument() else { return }
        self.currentUser = try? snapshot.data(as: User.self)
        
        //print("DEBUG: Current user is \(self.currentUser)")
    }
}
