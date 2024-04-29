//
//  SignUp.swift
//  FryftEats
//
//  Created by Victor Hoang on 4/28/24.
//

import Foundation
import SwiftUI

struct SignUp: View {
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
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Last Name", text: $viewModel.lastName)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Email", text: $viewModel.email)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            TextField("Username", text: $viewModel.username)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            SecureField("Password", text: $viewModel.password)
                .padding()
                .background(Color.white)
                .foregroundColor(.black)
                .cornerRadius(5)
            
            SecureField("Confirm Password", text: $viewModel.confirmPassword)
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
    }
}

#Preview {
    SignUp()
}
