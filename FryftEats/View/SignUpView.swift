//
//  SignUp.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct SignUpView: View {
    @ObservedObject var viewModel = SignUpViewModel()
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    @State private var errorMessage: String?

    var body: some View {
        VStack {
            Spacer()
            
            Text("Sign Up")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            if let errorMessage = errorMessage {
                Text(errorMessage)
                    .foregroundColor(.black)
            }
            
            TextField("First Name", text: $firstName)
                .placeholder(when: firstName.isEmpty) {
                    Text("First Name").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Last Name", text: $lastName)
                .placeholder(when: lastName.isEmpty) {
                    Text("Last Name").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Email", text: $email)
                .placeholder(when: email.isEmpty) {
                    Text("Email").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
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
            
            SecureField("Confirm Password", text: $confirmPassword)
                .placeholder(when: confirmPassword.isEmpty) {
                    Text("Confirm Password").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            Button(action: {
                viewModel.signUp(firstName: firstName, lastName: lastName, email: email, username: username, password: password, confirmPassword: confirmPassword, errorMessage: $errorMessage)
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color.gray)
            .foregroundColor(.white)
            .cornerRadius(5)
            
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

#Preview {
    SignUpView()
}
