//
//  StudentSquared2App.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 16/01/2024.
//

import SwiftUI
import Firebase

@main
struct StudentSquared2App: App {
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
