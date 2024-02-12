//
//  PopUp.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 12/02/2024.
//

import SwiftUI

class PopUpViewModel: ObservableObject {
    static let shared = PopUpViewModel()
        
        @Published var showMessage: Bool = false
        @Published var message: String = ""
        
        private init() {}
        
        static func show(message: String) {
            DispatchQueue.main.async {
                shared.message = message
                shared.showMessage = true
            }
        }
}

struct PopUpView: View {
    @ObservedObject private var viewModel = PopUpViewModel.shared

    var body: some View {
        Group {
            if viewModel.showMessage {
                VStack {
                    Text(viewModel.message)
                        .padding()
                        .background(Color.white)
                        .foregroundColor(Color.black)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .onTapGesture {
                            viewModel.showMessage = false
                        }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(Color.black.opacity(0.5))
                .edgesIgnoringSafeArea(.all)
            }
        }
    }
}

