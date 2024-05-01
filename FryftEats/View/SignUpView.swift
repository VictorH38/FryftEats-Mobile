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

    var body: some View {
        VStack {
            Spacer()
            
            Text("Sign Up")
                .font(.largeTitle)
                .foregroundColor(.white)
            
            if let errorMessage = viewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.black)
            }
            
            TextField("First Name", text: $viewModel.firstName)
                .placeholder(when: viewModel.firstName.isEmpty) {
                    Text("First Name").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Last Name", text: $viewModel.lastName)
                .placeholder(when: viewModel.lastName.isEmpty) {
                    Text("Last Name").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Email", text: $viewModel.email)
                .placeholder(when: viewModel.email.isEmpty) {
                    Text("Email").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Username", text: $viewModel.username)
                .placeholder(when: viewModel.username.isEmpty) {
                    Text("Username").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            SecureField("Password", text: $viewModel.password)
                .placeholder(when: viewModel.password.isEmpty) {
                    Text("Password").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
                .placeholder(when: viewModel.confirmPassword.isEmpty) {
                    Text("Confirm Password").foregroundColor(.gray)
                }
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            Button(action: {
                viewModel.signUp()
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
    }
}

#Preview {
    SignUpView()
}
