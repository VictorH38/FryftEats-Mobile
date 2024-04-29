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
                Spacer()
                
                Text("Login")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                
                if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.black)
                }
                
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
                
                Button(action: {
                    viewModel.login()
                }) {
                    Text("Login")
                        .frame(maxWidth: .infinity)
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.gray)
                .foregroundColor(.white)
                .cornerRadius(5)
                
                NavigationLink(destination: SignUp()) {
                    Text("Don't have an account yet? Sign Up")
                        .foregroundColor(.white)
                }
                .padding()
                
                Spacer()
            }
            .padding()
            .background(Color(hex: "#990000"))
            .ignoresSafeArea()
        }
    }
}

#Preview {
    Login()
}
