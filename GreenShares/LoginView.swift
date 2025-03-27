//
//  LoginView.swift
//  GreenShares
//
//  Created by Mark Le on 3/27/25.
//

import SwiftUI

struct LoginView: View {
    @Binding var isLoggedIn: Bool

    var body: some View {
        VStack(spacing: 20) {
            Text("Welcome to GreenShares")
                .font(.largeTitle)
            
            TextField("Username", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            SecureField("Password", text: .constant(""))
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Login") {
                isLoggedIn = true
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
        .padding()
    }
}

#Preview {
    LoginView(isLoggedIn: .constant(false))
}
