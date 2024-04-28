//
//  Login.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct Login: View {
    @ObservedObject var viewModel = LoginViewModel()

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.isLoggedIn {
                    Text("Logged in successfully!")
                }
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                }
                
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .border(Color.gray, width: 1)
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .border(Color.gray, width: 1)
                Button("Login", action: {
                    viewModel.login()
                })
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                NavigationLink(destination: SignUp()) {
                    Text("Don't have an account yet? Sign Up")
                }
                .padding()
            }
            .padding()
        }
    }
}

#Preview {
    Login()
}
