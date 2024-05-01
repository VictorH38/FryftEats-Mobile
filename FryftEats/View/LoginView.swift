//
//  Login.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct LoginView: View {
    @ObservedObject var viewModel = LoginViewModel()
    @State private var username = ""
    @State private var password = ""
    @State private var errorMessage: String?

    var body: some View {
        NavigationStack {
            VStack {
                Spacer()
                
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.black)
                }
                
                TextField("Username", text: $username)
                    .placeholder(when: username.isEmpty) {
                        Text("Username").foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                
                SecureField("Password", text: $password)
                    .placeholder(when: password.isEmpty) {
                        Text("Password").foregroundColor(.gray)
                    }
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .cornerRadius(5)
                
                Button(action: {
                    viewModel.login(username: username, password: password, errorMessage: $errorMessage)
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                NavigationLink(destination: SignUpView()) {
                    Text("Don't have an account yet? Sign Up")
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .background(Color(hex: "#990000"))
            .ignoresSafeArea()
            .onTapGesture {
                viewModel.dismissKeyboard()
            }
            .onAppear {
                errorMessage = nil
            }
        }
    }
}

#Preview {
    LoginView()
}
