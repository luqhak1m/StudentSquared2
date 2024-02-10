//
//  CustomTextField.swift
//  StudentSquared2
//
//  Created by Luqman Hakim on 17/01/2024.
//

import Foundation
import SwiftUI

struct CustomTextField: View {
    var placeholder: String
    @Binding var text: String
    var isSecure: Bool

    var body: some View {
        Group {
            if isSecure {
                SecureField(placeholder, text: $text)
                    .padding(.leading, 10)
            } else {
                TextField(placeholder, text: $text)
                    .padding(.leading, 10)
            }
        }
        .frame(width: 219, height: 32.15)
        .background(Color(.secondarySystemBackground))
        .cornerRadius(10)
        .font(.system(size: 14))
    }
}
